require 'readline'
module Gisele
  class VM
    class Command
      class Interactive < Agent

        def runone
          prompt = "\n? Please choose an action:(list, new, resume or quit)\ngisele-vm> "
          case s = Readline.readline(prompt, true)
          when /^l(ist)?/           then list_action
          when /^n(ew)?/            then new_action($2)
          when /^r(esume)?\s+(.+)$/ then resume_action($2)
          when /^q(uit)?/           then stop_action
          else
            puts "Unrecognized: #{s}"
          end
        rescue Interrupt
          puts "Interrupt on user request (graceful shutdown)."
          stop_action
        rescue Exception => ex
          puts ex.message
        end

        def list_action(lispy = Alf.lispy)
          rel = vm.proglist.to_relation
          rel = lispy.extend(rel, :waitlist => lambda{ waitlist.keys })
          rel = lispy.group(rel, [:root], :progs, :allbut => true)
          puts rel.to_relation
        end

        def new_action(args)
          vm.start(:main, [])
        end

        def resume_action(args)
          puid, *input = args.split(/\s+/)
          input = input.map{|x| Bytecode::Grammar.parse(x, :root => :arg).value}
          vm.resume(puid, input)
        end

        def stop_action
          vm.stop
        end

      end # class Interactive
    end # class Command
  end # class VM
end # module Gisele
