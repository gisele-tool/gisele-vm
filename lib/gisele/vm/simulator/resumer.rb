module Gisele
  class VM
    class Simulator < Agent

    private

      def runone
        prog = nil

        # Critical section to ensure that the agent won't be disconnected in
        # the middle of an enactement step.
        synchronize do
          if prog = vm.proglist.pick(:world)
            event = prog.waitlist.keys.sample
            debug("Sending event #{event} to Prog #{prog.puid}@#{prog.pc}")
            vm.resume(prog, [ event ])
          end
        end

        # No prog probably means that the VM is currently trying to disconnect.
        # We wait 0.1 msec out of the critical section to favor the disconnection
        # process.
        sleep(0.1) unless prog

      rescue Exception => ex
        error error_message(ex, "Simulation error:")
      end

    end # class Simulator
  end # class VM
end # module Gisele
