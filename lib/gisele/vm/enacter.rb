module Gisele
  class VM
    class Enacter < Agent

    private

      def runone
        if prog = vm.proglist.pick(:enacter)
          vm.progress(prog)
          true
        else
          # let the superclass known that something is wrong so that
          # it can manage the locks friendly (see Agent#run)
          false
        end
      rescue Exception => ex
        puid = (prog && prog.puid) || ''
        msg  = "Progress error (#{puid}): #{ex.message}\n" + ex.backtrace.join("\n")
        error(msg) rescue nil
        false
      end

    end # class Enacter
  end # class VM
end # module Gisele
