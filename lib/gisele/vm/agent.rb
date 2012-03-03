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
      end

      def start(label)
        vm(nil).run(:start, [ label ])
      end

      def run
        @run = true
        run_one(@proglist.pick) while run?
      end

      def resume(puid, input = [])
        vm(nil).run(:resume, [ input, puid ])
      end

      def stop
        @run = false
      end

      def dump
        @proglist.to_relation
      end

    private

      def run_one(prog)
        vm(prog.puid).run(:run, [ prog ])
      rescue Interrupt
      rescue Exception => ex
        $stderr.puts "Fatal exception (#{prog.puid}): #{ex.message}"
        $stderr.puts ex.backtrace.join("\n")
      end

      def run?
        @run
      end

      def vm(puid = nil)
        VM.new puid, @bytecode, @proglist, @event_interface
      end

    end # class Agent
  end # class VM
end # module Gisele
