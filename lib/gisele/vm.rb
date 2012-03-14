require 'logger'
require 'forwardable'
require_relative 'vm/errors'
require_relative 'vm/robustness'
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
require_relative 'vm/enacter'
module Gisele
  class VM
    extend Forwardable

    attr_reader   :bytecode
    attr_reader   :registry
    attr_reader   :kernel
    attr_accessor :proglist
    attr_accessor :event_manager

    def initialize(bytecode = [:gvm])
      @bytecode  = (Kernel.bytecode + Bytecode.coerce(bytecode)).verify!
      @registry  = Registry.new(self)
      @kernel    = Kernel.new
      init_lifecycle

      # registration
      yield(self) if block_given?
      @proglist      ||= ProgList.memory
      @event_manager ||= EventManager.new

      # post installation of prior components
      @registry.register @event_manager, true
      @registry.register @proglist, true

      # install the kernel as last one (the last one disconnected)
      @registry.register @kernel
    end

    def self.compile(gis)
      gts = Compiling::Gisele2Gts.compile(gis)
      bc  = Compiling::Gts2Bytecode.call(gts)
    end

    def vm
      self
    end

    include Robustness
    include Logging
    include Lifecycle

    def_delegators :registry,      :components,
                                   :register,
                                   :unregister,
                                   :connect,
                                   :disconnect,
                                   :connected?

    def_delegators :kernel,        :start,
                                   :resume,
                                   :progress

    def_delegators :proglist,      :pick,
                                   :fetch,
                                   :save

    def_delegators :event_manager, :event

    def progs(restriction = nil)
      proglist.to_relation(restriction)
    end

  end
end
