module Gisele
  class VM
    module Logging
      extend Forwardable

      def logger=(logger)
        @logger = logger
      end

      def logger
        @logger ||= NullObject.new
      end

      def_delegators :logger, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :logger, :debug?, :info?, :warn?, :error?, :fatal?
    end # module Logging
  end # class VM
end # module Gisele
