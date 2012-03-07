module Gisele
  class VM
    class Agent

      attr_reader   :bytecode
      attr_reader   :proglist
      attr_accessor :event_interface

      def initialize(bytecode, proglist = nil, event_interface = nil)
        @bytecode        = bytecode
        @proglist        = proglist || ProgList.memory.threadsafe
        @event_interface = event_interface
      end

      def start(label)
        kernel(nil).run(:start, [ label ])
      end

      def run
        @run = true
        while run?
          prog = @proglist.pick(:enacter) # blocking call
          run_one(prog) if prog and run? # prog may be nil at release time
        end
      end

      def runone(puid)
        kernel(puid).run(:run, [ ])
      end

      def resume(puid, input = [])
        kernel(puid).run(:resume, [ input ])
      end

      def stop
        @run = false
        @proglist.release
      end

      def dump
        @proglist.to_relation
      end

      def run_one(prog)
        kernel(prog.puid).run(:run, [ ])
      rescue Interrupt
        stop
      rescue Exception => ex
        $stderr.puts "Fatal exception (#{prog.puid}): #{ex.message}"
        $stderr.puts ex.backtrace.join("\n")
      end

      def run?
        @run
      end

      def vm
        VM.new(bytecode) do |vm|
          vm.proglist      = @proglist
          vm.event_manager = @event_interface if @event_interface
        end
      end

      def kernel(puid = nil)
        Kernel.new vm, puid
      end

    end # class Agent
  end # class VM
end # module Gisele
