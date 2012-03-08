module Gisele
  class VM
    class Enacter < Agent

    private

      def run
        while connected?
          prog = nil
          synchronize do
            prog = vm.proglist.pick(:enacter)
            run_prog(prog) if prog
          end
          # no prog has been found last time => probably in shutdown process
          # sleep a bit so as to favor the disconnection process now...
          sleep(0.1) unless prog
        end
      end

      def run_prog(prog)
        vm.progress(prog)
      rescue Exception => ex
        msg = "Error while executing #{prog.puid}: #{ex.message}\n" +
              ex.backtrace.join("\n")
        error(msg) rescue nil
      end

    end # class Enacter
  end # class VM
end # module Gisele
