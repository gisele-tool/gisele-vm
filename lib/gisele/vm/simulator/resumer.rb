module Gisele
  class VM
    module Simulator
      class Resumer < Component

        def connect
          super
          @timer = EM.add_periodic_timer(0.01, &method(:resume))
          EM.reactor_thread
        end

        def disconnect
          super
          @timer.cancel
        end

      private

        def resume
          prog = vm.pick(:waitfor => :world)
          resume_one(prog) if prog
        end

        def resume_one(prog)
          event = prog.waitlist.keys.sample
          debug("Resuming Prog #{prog.puid}@#{prog.pc} -> #{event}")
          vm.resume(prog, [ event ])
        rescue Exception => ex
          error error_message(ex, "Resume error (#{prog.puid}):")
        end

        def welcome_message
          "Simulator(resumer) entering loop."
        end

        def goodbye_message
          "Simulator(resumer) stopped."
        end

      end # class Resumer
    end # class Simulator
  end # class VM
end # module Gisele
