require 'logger'
require_relative 'vm/errors'
require_relative 'vm/gts'
require_relative 'vm/prog'
require_relative 'vm/prog_list'
require_relative 'vm/bytecode'
require_relative 'vm/opcodes'
require_relative 'vm/kernel'
require_relative 'vm/agent'
module Gisele
  class VM

    # A Logger instance
    attr_reader :logger

    # The ProgList instance used in this VM
    attr_reader :proglist

    # The event manager used in this VM
    attr_reader :event_manager

    def initialize
      self.logger         = Logger.new($stdout)
      self.proglist       = ProgList.memory.threadsafe
      self.event_manager  = Proc.new do |kind,args|
        if logger
          logger.info("Process(#{args.first}): #{kind}(#{args[1..-1].join(',')})")
        end
      end
      yield(self) if block_given?
    end

    ### Logging

    def logger=(arg)
      unless arg.nil? or Logger===arg
        raise ArgumentError, "Invalid logger: #{arg.inspect}"
      end
      @logger = arg
    end

    ### ProgList

    def proglist=(arg)
      unless ProgList===arg
        raise ArgumentError, "Invalid prog list: #{arg.inspect}"
      end
      @proglist = arg
    end

    def pick(*args, &bl)
      @proglist.pick(*args, &bl)
    end

    def fetch(*args, &bl)
      @proglist.fetch(*args, &bl)
    end

    def save(*args, &bl)
      @proglist.save(*args, &bl)
    end

    ### EventManager

    def event_manager=(arg)
      unless arg.respond_to?(:call)
        raise ArgumentError, "Invalid event manager: #{arg.inspect}"
      end
      @event_manager = arg
    end

    def event(kind, args)
      @event_manager.call(kind, args)
    end

  end
end
