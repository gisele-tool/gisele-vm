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
        info(welcome_message)
      end

      def disconnect
        raise InvalidStateError, "Not connected" unless connected?
        @connected = false
        info(goodbye_message)
      end

      def connected?
        @connected
      end

      def connected!
        raise InvalidStateError, "Not connected" unless connected?
      end

      def_delegators :vm, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :vm, :debug?, :info?, :warn?, :error?, :fatal?

    private

      def component_name
        self.class.name.to_s.split('::').last
      end

      def welcome_message
        "Component <#{component_name}> entering heartbeat."
      end

      def goodbye_message
        "Component <#{component_name}> quit heartbeat."
      end

    end # class Component
  end # class VM
end # module Gisele
