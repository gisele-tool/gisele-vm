module Gisele
  class VM
    class Enacter < Agent

    private

      def runone
        prog = vm.proglist.pick(:enacter)
        if prog
          vm.progress(prog)
        else
          # no prog has been found last time => probably in shutdown process
          # sleep a bit so as to favor disconnecting...
          sleep(0.1) rescue nil
        end
      rescue Exception => ex
        puid = (prog && prog.puid) || ''
        msg  = "Progress error (#{puid}): #{ex.message}\n" + ex.backtrace.join("\n")
        error(msg) rescue nil
      end

    end # class Enacter
  end # class VM
end # module Gisele
