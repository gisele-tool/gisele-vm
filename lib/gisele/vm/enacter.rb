module Gisele
  class VM
    class Enacter < Component

    private

      def runone(prog)
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
