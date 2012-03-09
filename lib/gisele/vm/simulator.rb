module Gisele
  class VM
    class Simulator < Agent

    private

      def runone
        if prog = vm.proglist.pick(:world)
          vm.resume(prog, [ prog.waitlist.keys.sample ])
          true
        else
          # let the superclass known that something is wrong so that
          # it can manage the locks friendly (see Agent#run)
          false
        end
      rescue Exception => ex
        puid = (prog && prog.puid) || ''
        msg  = "Simulation error (#{puid}): #{ex.message}\n" + ex.backtrace.join("\n")
        error(msg) rescue nil
      end

    end # class Simulator
  end # class VM
end # module Gisele
