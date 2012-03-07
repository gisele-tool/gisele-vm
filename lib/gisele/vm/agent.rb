module Gisele
  class VM
    class Agent

      attr_reader   :bytecode
      attr_reader   :proglist
      attr_accessor :event_interface

      def initialize(bytecode, proglist = nil, event_interface = nil)
        @bytecode        = Bytecode.coerce(bytecode) + Bytecode.kernel
        @proglist        = proglist || ProgList.memory.threadsafe
        @event_interface = event_interface
        @bytecode.verify!
      end

      def start(label)
        vm(nil).run(:start, [ label ])
      end

      def run
        @run = true
        while run?
          prog = @proglist.pick          # blocking call
          run_one(prog) if prog and run? # prog may be nil at release time
        end
      end

      def runone(puid)
        vm(puid).run(:run, [ ])
      end

      def resume(puid, input = [])
        vm(puid).run(:resume, [ input ])
      end

      def stop
        @run = false
        @proglist.release
      end

      def dump
        @proglist.to_relation
      end

    private

      def run_one(prog)
        vm(prog.puid).run(:run, [ ])
      rescue Interrupt
        stop
      rescue Exception => ex
        $stderr.puts "Fatal exception (#{prog.puid}): #{ex.message}"
        $stderr.puts ex.backtrace.join("\n")
      end

      def run?
        @run
      end

      def vm(puid)
        Kernel.new puid, @bytecode, @proglist, @event_interface
      end

    end # class Agent
  end # class VM
end # module Gisele
