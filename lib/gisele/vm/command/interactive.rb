module Gisele
  class VM
    class Command
      class Interactive

        attr_reader :agent

        def initialize(agent)
          require 'logger'
          @agent  = agent
          @runner = nil
          @log    = Logger.new($stdout)
          agent.event_interface = self
        end

        def stop?
          defined?(@stop) && @stop
        end

        def stop!
          @agent.stop  if @agent
          @runner.join if @runner
          @stop = true
        end

        def run!
          @runner = Thread.new{ @agent.run }
          run_one until stop?
        end

        def run_one
          puts "? Please choose an action:(list, new, resume, quit or help)\n"
          case s = $stdin.gets
          when /^l(ist)?/           then list_action
          when /^n(ew)?\s+(.+)$/    then new_action($2)
          when /^r(esume)?\s+(.+)$/ then resume_action($2)
          when /^q(uit)?/           then stop_action
          else
            puts "Unrecognized: #{s}"
          end
        rescue Interrupt
          puts "Interrupt on user request (graceful shutdown)."
          stop!
        rescue Exception => ex
          puts ex.message
        end

        def list_action
          puts agent.dump
        end

        def new_action(args)
          agent.start(args.strip.to_sym)
        end

        def resume_action(args)
          puid, *input = args.split(/\s+/)
          agent.resume(puid, input.map{|x| Gvm.parse(x, :root => :arg).value})
        end

        def stop_action
          stop!
        end

        def call(puid, kind, args) ### event interface
          @log.info "Process(#{puid}): #{kind}(#{args.join(', ')})"
          puts agent.dump
        end

      end # class Interactive
    end # class Command
  end # class VM
end # module Gisele
