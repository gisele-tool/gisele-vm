module Gisele
  class VM
    class Kernel
      class Runner
        include Opcodes

        attr_reader :vm
        attr_reader :opcodes
        attr_reader :prog

        def initialize(vm = VM.new, prog = nil)
          @vm       = vm
          @prog     = prog
          @stack    = []
          @opcodes  = []
        end

        def run(at = nil, stack = [])
          @stack = stack
          enlist_bytecode_at(at) if at
          until @opcodes.empty?
            op = @opcodes.shift
            send :"op_#{op.first}", *op[1..-1]
          end
          @stack
        end

      private

        ### self

        def puid
          prog && prog.puid
        end

        ### stack

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

        ### code

        def enlist_bytecode_at(label)
          @opcodes += vm.bytecode[label]
        end

      end # class Runner
    end # class Kernel
  end # class VM
end # module Gisele
