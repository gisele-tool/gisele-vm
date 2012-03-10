require 'logger'
require 'forwardable'
require_relative 'vm/errors'
require_relative 'vm/null_object'
require_relative 'vm/logging'
require_relative 'vm/component'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/event'
require_relative 'vm/event_manager'
require_relative 'vm/registry'
require_relative 'vm/bytecode'
require_relative 'vm/kernel'
require_relative 'vm/lifecycle'
require_relative 'vm/agent'
require_relative 'vm/enacter'
require_relative 'vm/simulator'
module Gisele
  class VM
    extend Forwardable
    include Logging

    # The executed bytecode
    attr_reader :bytecode

    # The component registry
    attr_reader :registry

    # The ProgList instance used in this VM
    attr_reader :proglist

    # The event manager used in this VM
    attr_reader :event_manager

    def initialize(bytecode = [:gvm])
      init_lifecycle
      @registry           = Registry.new
      self.bytecode       = bytecode
      self.proglist       = ProgList.memory.threadsafe
      self.event_manager  = EventManager.new
      yield(self) if block_given?
    end

    ### Bytecode

    def bytecode=(bytecode)
      @bytecode = Kernel.bytecode + Bytecode.coerce(bytecode)
      @bytecode.verify!
    end

    ### Registry

    def_delegators :registry, :components, :register, :unregister

    ### ProgList

    def proglist=(arg)
      unless ProgList===arg
        raise ArgumentError, "Invalid prog list: #{arg.inspect}"
      end
      unregister(@proglist) if @proglist
      register(@proglist = arg)
    end
    def_delegators :proglist, :pick, :fetch, :save

    ### EventManager

    def event_manager=(arg)
      arg = case arg
      when EventManager then arg
      when Proc         then EventManager.new(&arg)
      else
        raise ArgumentError, "Invalid event manager: #{arg.inspect}"
      end
      unregister(@event_manager) if @event_manager
      register(@event_manager = arg)
    end
    def_delegators :event_manager, :event

    ### Kernel

    def start(at, input)
      at    = valid_label!(at)
      input = valid_input!(input)

      kernel(nil) do |k|
        stack = k.run(:start, [ input, at ])
        stack.first
      end
    end

    def resume(puid, input)
      prog = Prog===puid ? puid : fetch(puid)
      input = valid_input!(input)
      unless prog.waitfor == :world
        raise InvalidStateError, "Prog `#{puid}` does not wait for world stimuli"
      end

      kernel(prog) do |k|
        k.run(:resume, [ input ])
      end
    end

    def progress(puid)
      prog = Prog===puid ? puid : fetch(puid)
      unless prog.waitfor == :enacter
        raise InvalidStateError, "Prog `#{puid}` does not wait for enactement progress"
      end

      kernel(prog) do |k|
        k.run(:progress, [ ])
      end
    end

    ### Lifecycle

    include Lifecycle

  private

    def kernel(prog = nil)
      if block_given?
        yield Kernel.new(self, prog)
      else
        Kernel.new(self, prog)
      end
    end

    def valid_label!(at)
      unless bytecode[at]
        raise InvalidLabelError, "Unknown label: `#{at.inspect}`"
      end
      at
    end

    def valid_input!(input)
      unless Array===input
        raise InvalidInputError, "Invalid VM input: `#{input.inspect}`"
      end
      input
    end

  end
end
