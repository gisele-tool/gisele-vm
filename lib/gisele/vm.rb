require 'logger'
require 'forwardable'
require_relative 'vm/errors'
require_relative 'vm/null_object'
require_relative 'vm/component'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/event'
require_relative 'vm/event_manager'
require_relative 'vm/bytecode'
require_relative 'vm/kernel'
require_relative 'vm/agent'
require_relative 'vm/lifecycle'
module Gisele
  class VM
    extend Forwardable

    # The executed bytecode
    attr_reader :bytecode

    # A Logger instance
    attr_reader :logger

    # The ProgList instance used in this VM
    attr_reader :proglist

    # The event manager used in this VM
    attr_reader :event_manager

    def initialize(bytecode = [:gvm])
      init_lifecycle
      self.bytecode       = bytecode
      self.logger         = Logger.new($stdout)
      self.proglist       = ProgList.memory.threadsafe
      self.event_manager  = EventManager.new
      yield(self) if block_given?
    end

    ### Bytecode

    def bytecode=(bytecode)
      @bytecode = Kernel.bytecode + Bytecode.coerce(bytecode)
      @bytecode.verify!
    end

    ### Logging

    def logger=(arg)
      unless arg.nil? or Logger===arg
        raise ArgumentError, "Invalid logger: #{arg.inspect}"
      end
      @logger = arg
    end
    def_delegators :logger, :debug,  :info,  :warn,  :error,  :fatal
    def_delegators :logger, :debug?, :info?, :warn?, :error?, :fatal?

    ### ProgList

    def proglist=(arg)
      unless ProgList===arg
        raise ArgumentError, "Invalid prog list: #{arg.inspect}"
      end
      @proglist = arg
    end
    def_delegators :proglist, :pick, :fetch, :save

    ### EventManager

    def event_manager=(arg)
      @event_manager = case arg
      when EventManager then arg
      when Proc         then EventManager.new(&arg)
      else
        raise ArgumentError, "Invalid event manager: #{arg.inspect}"
      end
    end
    def_delegators :event_manager, :event

    ### Kernel

    def start(at, input)
      at    = valid_label!(at)
      input = valid_input!(input)
      stack = kernel(nil).run(:start, [ input, at ])
      stack.first
    end

    def resume(puid, input)
      prog = Prog===puid ? puid : fetch(puid)
      input = valid_input!(input)
      unless prog.waitfor == :world
        raise InvalidStateError, "Prog `#{puid}` does not wait for world stimuli"
      end
      kernel(prog).run(:resume, [ input ])
    end

    def progress(puid)
      prog = Prog===puid ? puid : fetch(puid)
      unless prog.waitfor == :enacter
        raise InvalidStateError, "Prog `#{puid}` does not wait for enactement progress"
      end
      kernel(prog).run(:progress, [ ])
    end

    ### Lifecycle

    include Lifecycle

    def components
      [ proglist, event_manager ]
    end

  private

    def kernel(prog = nil)
      Kernel.new(self, prog)
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
