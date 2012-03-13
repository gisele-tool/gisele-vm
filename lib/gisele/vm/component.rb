module Gisele
  class VM
    class Component
      extend Forwardable

      attr_reader :lock

      def initialize
        @lock      = Mutex.new
        @vm        = nil
        @connected = false
      end

      def synchronize(&bl)
        @lock.synchronize(&bl)
      end

      def vm
        @vm || NullObject.new
      end

      def registered(vm)
        @vm = vm
      end

      def unregistered
        @vm = nil
      end

      def registered?
        !@vm.nil?
      end

      def registered!
        raise InvalidStateError, "Not registered" unless registered?
      end

      def connect
        registered!
        raise InvalidStateError, "Already connected" if connected?
        @connected = true
      end

      def disconnect
        raise InvalidStateError, "Not connected" unless connected?
        @connected = false
      end

      def connected?
        @connected
      end

      def connected!
        raise InvalidStateError, "Not connected" unless connected?
      end

      def_delegators :vm, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :vm, :debug?, :info?, :warn?, :error?, :fatal?
    end # class Component
  end # class VM
end # module Gisele
