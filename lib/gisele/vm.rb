require 'logger'
require 'forwardable'
require_relative 'vm/errors'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/event'
require_relative 'vm/event_manager'
require_relative 'vm/bytecode'
require_relative 'vm/kernel'
require_relative 'vm/agent'
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

    def start(at)
      kernel(nil).run(:start, [ at ])
    end

    def resume(puid, input)
      kernel(puid).run(:resume, [ input ])
    end

  private

    def kernel(puid = nil)
      Kernel.new(self, puid)
    end

  end
end
