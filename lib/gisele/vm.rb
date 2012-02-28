require_relative 'vm/errors'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/opcodes'
module Gisele
  class VM

    def initialize(uuid, bytecode, proglist = ProgList.new)
      @uuid     = uuid
      @bytecode = bytecode
      @proglist = proglist
      @stack    = []
      @opcodes  = []
    end

    def run
      push 0
      op_pushc
      until @opcodes.empty?
        op = @opcodes.shift
        send :"op_#{op.first}", *op[1..-1]
      end
    end

  private

    def push(x)
      @stack << x
    end

    def pop
      @stack.pop
    end

    def peek
      @stack.last
    end

    include Opcodes
  end
end