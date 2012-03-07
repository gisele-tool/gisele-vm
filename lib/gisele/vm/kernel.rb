module Gisele
  class VM
    class Kernel
      attr_reader :puid
      attr_reader :stack
      attr_reader :opcodes
      attr_reader :proglist
      attr_reader :event_interface

      def initialize(puid, bytecode = [], proglist = nil, event_interface = nil)
        @puid     = puid
        @bytecode = bytecode
        @proglist = proglist || ProgList.memory
        @stack    = []
        @opcodes  = []
        @event_interface = event_interface
      end

      def run(at = nil, stack = [], trace = false)
        @stack = stack
        enlist_bytecode_at(at) if at
        until @opcodes.empty?
          op = @opcodes.shift
          send :"op_#{op.first}", *op[1..-1]
        end
      end

    private

      def current_prog
        fetch(puid)
      end

      def fork(at)
        Prog.new(:parent => puid, :pc => at, :waitfor => :enacter)
      end

      def event(kind, args)
        event_interface.call(@puid, kind, args) if event_interface
      end

      def enlist_bytecode_at(label)
        @opcodes += @bytecode[label]
      end

      def push(x)
        @stack << x
      end

      def pop(n = nil)
        if n.nil?
          @stack.pop
        else
          n.times.map{ @stack.pop }
        end
      end

      def peek
        @stack.last
      end

      def fetch(puid)
        @proglist.fetch(puid)
      end

      def save(prog)
        if Array===prog
          prog.map{|p| @proglist.save(p) }
        else
          @proglist.save(prog)
        end
      end

      include Opcodes
    end # class Kernel
  end # class VM
end # module Gisele
