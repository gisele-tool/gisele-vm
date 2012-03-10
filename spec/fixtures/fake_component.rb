module Gisele
  class VM
    module FakeComponent
      def connect(vm)
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
