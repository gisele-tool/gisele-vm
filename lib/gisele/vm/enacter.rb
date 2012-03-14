module Gisele
  class VM
    class Enacter < Agent

    private

      def runone
        prog = nil

        # Critical section to ensure that the agent won't be disconnected in
        # the middle of an enactement step.
        synchronize do
          return unless connected? # could be disconnected in the meantime
          if prog = vm.pick(:waitfor => :enacter)
            debug("Enacting Prog #{prog.puid}@#{prog.pc}")
            vm.progress(prog)
          end
        end

        # No Prog means either that the VM is trying to disconnect or that the
        # ProgList changed but has nothing for the enacter. We pass here out of
        # the critical section to favor the other agents...
        Thread.pass unless prog

      rescue Exception => ex
        error error_message(ex, "Progress error (#{prog.puid}):")
      end

    end # class Enacter
  end # class VM
end # module Gisele
