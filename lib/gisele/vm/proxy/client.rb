require 'drb'
module Gisele
  class VM
    module Proxy
      class Client
        include Lifecycle
        extend  Forwardable

        attr_reader :options
        attr_reader :logger
        attr_reader :components

        def initialize(options = {})
          init_lifecycle
          @options    = Proxy.default_options.merge(options)
          @logger     = Logger.new($stdout, Logger::DEBUG)
          @components = []
        end

        def run
          @vm = DRbObject.new nil, options[:uri]
          super
        end

        def add_agent(agent)
          @components << agent
        end

        def_delegators :"@vm", :start, :progress, :resume
        def_delegators :"@vm", :proglist

        def_delegators :logger, :debug,  :info,  :warn,  :error,  :fatal
        def_delegators :logger, :debug?, :info?, :warn?, :error?, :fatal?
      end # Server
    end # module Proxy
  end # class VM
end # module Gisele
