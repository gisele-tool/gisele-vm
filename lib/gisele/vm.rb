require_relative 'vm/errors'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/gvm'
require_relative 'vm/opcodes'
module Gisele
  class VM

    attr_reader :stack
    attr_reader :opcodes
    attr_reader :proglist

    def initialize(puid, bytecode, proglist = ProgList.new)
      @puid     = puid
      @bytecode = bytecode
      @proglist = proglist
      @stack    = []
      @opcodes  = []
    end

    def run
      push_loader
      until @opcodes.empty?
        op = @opcodes.shift
        send :"op_#{op.first}", *op[1..-1]
      end
    end

  private

    def push_loader
      @opcodes << [:puid]   # push self puid
      @opcodes << [:fetch]  # fetch the corresponding Prog
      @opcodes << [:pc]     # push the program counter
      @opcodes << [:pushc]  # load the instructions
      @opcodes << [:pop]    # pop the Prog
    end

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
