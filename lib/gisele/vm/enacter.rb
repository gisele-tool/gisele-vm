module Gisele
  class VM
    class Enacter < Agent

    private

      def runone
        prog = nil

        # Critical section to ensure that the agent won't be disconnected in
        # the middle of an enactement step.
        synchronize do
          if prog = vm.proglist.pick(:enacter)
            debug("Enacting Prog #{prog.puid}@#{prog.pc}")
            vm.progress(prog)
          end
        end

        # No prog probably means that the VM is currently trying to disconnect.
        # We wait 0.1 msec out of the critical section to favor the disconnection
        # process.
        sleep(0.1) unless prog

      rescue Exception => ex
        error error_message(ex, "Progress error (#{prog.puid}):")
      end

    end # class Enacter
  end # class VM
end # module Gisele
