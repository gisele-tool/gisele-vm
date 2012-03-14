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
              return unless connected? # could be disconnected in the meantime
              if prog = vm.pick(:waitfor => :world)
                event = prog.waitlist.keys.sample
                info("Sending event #{event} to Prog #{prog.puid}@#{prog.pc}")
                vm.resume(prog, [ event ])
              end
            end

            if prog
              sleep(options[:sleep_time] || 0)
            else
              # No Prog means either that the VM is trying to disconnect or that the
              # ProgList changed but has nothing for the resumer. We pass here out of
              # the critical section to favor the other agents...
              Thread.pass unless prog
            end

          rescue Interrupt
          rescue Exception => ex
            error error_message(ex, "Simulation error:")
          end

      end # class Resumer
    end # class Simulator
  end # class VM
end # module Gisele
