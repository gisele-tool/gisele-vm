module Gisele
  class VM
    class Simulator
      class Resumer < Agent

        def default_options
          { :sleep_time => nil }
        end

        private

          def runone
            prog = nil

            # Critical section to ensure that the agent won't be disconnected in
            # the middle of an enactement step.
            synchronize do
              if prog = vm.proglist.pick(:waitfor => :world)
                event = prog.waitlist.keys.sample
                debug("Sending event #{event} to Prog #{prog.puid}@#{prog.pc}")
                vm.resume(prog, [ event ])
              end
            end

            if prog
              sleep(options[:sleep_time] || 0)
            else
              # No prog probably means that the VM is currently trying to disconnect.
              # We wait 0.1 msec out of the critical section to favor the disconnection
              # process.
              sleep(0.1)
            end

          rescue Interrupt
          rescue Exception => ex
            error error_message(ex, "Simulation error:")
          end

      end # class Resumer
    end # class Simulator
  end # class VM
end # module Gisele
