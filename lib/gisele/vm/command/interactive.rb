module Gisele
  class VM
    class Command
      class Interactive

        attr_reader :agent

        def initialize(agent)
          require 'logger'
          @agent = agent
          @log   = Logger.new($stdout)
          agent.event_interface = self
        end

        def stop?
          defined?(@stop) && @stop
        end

        def stop!
          @stop = true
        end

        def run!
          runner = Thread.new{
            begin
              @agent.run
            rescue Exception => ex
              $stderr.puts "Fatal exception: #{ex.message}"
              stop!
            end
          }
          run_one until stop?
        end

        def run_one
          puts "? Please choose an action:(list, new, resume, quit or help)\n"
          case s = $stdin.gets
          when /^l(ist)?/          then puts agent.dump
          when /^n(ew)?\s+(.+)$/   then agent.start($2.strip.to_sym)
          when /^r(esume)?\s+(.+)$/ then agent.resume($2.strip)
          when /^q(uit)?/          then stop!
          else
            puts "Unrecognized: #{s}"
          end
        rescue Exception => ex
          puts ex.message
        end

        def call(puid, kind, args)
          @log.info "Process(#{puid}): #{kind}(#{args.join(', ')})"
          puts agent.dump
        end

      end # class Interactive
    end # class Command
  end # class VM
end # module Gisele
