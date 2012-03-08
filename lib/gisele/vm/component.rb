module Gisele
  class VM
    module Component
      extend Forwardable

      def vm
        @vm || NullObject.new
      end

      def connect(vm)
        @vm = vm
      end

      def disconnect
        @vm = nil
      end

      def connected?
        !@vm.nil?
      end

      def_delegators :vm, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :vm, :debug?, :info?, :warn?, :error?, :fatal?
    end # module Component
  end # class VM
end # module Gisele
