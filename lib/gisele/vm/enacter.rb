module Gisele
  class VM
    class Enacter < Component

      def connect
        super
        @timer = EM.add_periodic_timer(0.01, &method(:enact))
        EM.reactor_thread
      end

      def disconnect
        super
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

      def welcome_message
        "Enacter entering loop."
      end

      def goodbye_message
        "Enacter stopped."
      end

    end # class Enacter
  end # class VM
end # module Gisele
