module Gisele
  class VM
    class Command
      class Interactive < Component

        module Handler
          attr_accessor :interactive
          def notify_readable
            case s = @io.readline.strip
            when /^l(ist)?$/           then interactive.list_action
            when /^n(ew)?$/            then interactive.new_action($2)
            when /^r(esume)?\s+(.+)$/  then interactive.resume_action($2)
            when /^q(uit)?$/           then interactive.stop_action
            else
              puts "Unrecognized: #{s}" unless s.empty?
            end
          rescue Exception => ex
            puts "ERROR: #{ex.message}"
          ensure
            interactive.prompt
          end
        end

        def connect
          super
          EM.watch($stdin, Handler){|c|
            c.interactive = self
            c.notify_readable = true
          }
          prompt
          EM.reactor_thread
        end

        def prompt
          $stdout << "\n? Please choose an action:(list, new, resume or quit)\ngisele-vm> "
        end

        def list_action(lispy = Alf.lispy)
          rel = vm.progs
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

        def welcome_message
          "Interactive console entering loop."
        end

        def goodbye_message
          "Interactive console closed."
        end

      end # class Interactive
    end # class Command
  end # class VM
end # module Gisele
