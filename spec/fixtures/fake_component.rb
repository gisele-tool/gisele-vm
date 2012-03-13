module Gisele
  class VM
    module FakeComponent
      def registered(vm)
        @vm = vm
      end
      def unregistered
        @vm = nil
      end
      def registered?
        !@vm.nil?
      end
      def connect
        @connected = true
      end
      def disconnect
        @connected = false
      end
      def connected?
        @connected
      end
    end
  end
end
