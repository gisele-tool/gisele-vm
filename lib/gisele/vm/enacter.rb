module Gisele
  class VM
    class Enacter < Component

      def enter_heartbeat
        @timer = EM.add_periodic_timer(0.01, &method(:enact))
      end

      def leave_heartbeat
        @timer.cancel
      end

    private

      def enact
        prog = vm.pick(:waitfor => :enacter)
        enact_one(prog) if prog
      end

      def enact_one(prog)
        debug("Enacting Prog #{prog.puid}@#{prog.pc}")
        vm.progress(prog)
      rescue Exception => ex
        error error_message(ex, "Progress error (#{prog.puid}):")
      end

    end # class Enacter
  end # class VM
end # module Gisele
