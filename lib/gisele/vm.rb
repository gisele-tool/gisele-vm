require_relative 'vm/errors'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/gvm'
require_relative 'vm/opcodes'
module Gisele
  class VM

    attr_reader :puid
    attr_reader :stack
    attr_reader :opcodes
    attr_reader :proglist
    attr_reader :event_interface

    def initialize(puid, bytecode, proglist = nil, event_interface = self)
      @puid     = puid
      @bytecode = bytecode
      @proglist = proglist || ProgList.memory
      @stack    = []
      @opcodes  = []
      @event_interface = event_interface
    end

    def run
      push_loader
      until @opcodes.empty?
        op = @opcodes.shift
        send :"op_#{op.first}", *op[1..-1]
      end
    end

  private

    def be(prog)
      @puid = prog.puid
    end

  private

    def push_loader
      @opcodes << [:puid]     # push self puid
      @opcodes << [:fetch]    # fetch the corresponding Prog
      @opcodes << [:get, :pc] # push the program counter
      @opcodes << [:then]     # load the instructions
      @opcodes << [:pop]      # pop the Prog
    end

  private ### lifecycle

    def current_prog(with = nil)
      prog = fetch(puid)
      prog = prog.merge(with) if with
      prog
    end

    def fork(at)
      Prog.new(:parent => puid, :pc => at, :progress => true)
    end

  private ### event management

    def event(kind, args)
      event_interface.call(@puid, kind, args)
    end

    def call(puid, kind, args)
      puts "#{kind}(#{puid}): #{args.inspect}"
    end
    public :call

  private ### code stack management

    def enlist_bytecode_at(label)
      @opcodes += @bytecode[label]
    end

  private ### data stack management

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

  private ### progs management

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

    def pick(&bl)
      @proglist.pick(&bl)
    end

  private ### opcodes

    include Opcodes
  end
end
