module Gisele
  class VM
    class Simulator
      class Starter < Agent

        def default_options
          { :sleep_time => 1 }
        end

        private

          def runone

            # Critical section to ensure that the agent won't be disconnected in
            # the middle of an enactement step.
            synchronize do
              debug("Starting a new process at :main")
              vm.start(:main, [])
            end
            sleep(options[:sleep_time] || 0)

          rescue Interrupt
          rescue Exception => ex
            error error_message(ex, "Simulation error:")
          end

      end # class Starter
    end # class Simulator
  end # class VM
end # module Gisele
