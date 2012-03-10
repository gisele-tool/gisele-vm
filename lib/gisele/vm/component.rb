module Gisele
  class VM
    class Component
      extend Forwardable

      attr_reader :lock

      def initialize
        @lock = Mutex.new
      end

      def synchronize(&bl)
        @lock.synchronize(&bl)
      end

      def vm
        @vm || NullObject.new
      end

      def connect(vm)
        raise InvalidStateError, "Already connected" if connected?
        @vm = vm
      end

      def disconnect
        raise InvalidStateError, "Not connected" unless connected?
        @vm = nil
      end

      def connected?
        !@vm.nil?
      end

      def_delegators :vm, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :vm, :debug?, :info?, :warn?, :error?, :fatal?
    end # class Component
  end # class VM
end # module Gisele
