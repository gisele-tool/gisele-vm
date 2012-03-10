module Gisele
  class VM
    class Registry < Component

      attr_reader :components

      def initialize
        super()
        @components = []
        @connected  = []
      end

      def register(component)
        raise NotImplementedError,
              "Hot registration is not implemented." if connected?
        @components << component
      end

      def unregister(component)
        raise NotImplementedError,
              "Hot unregistration is not implemented." if connected?
        @components.delete(component)
      end

      def connect(vm)
        super
        @components.each do |c|
          c.connect(vm)
          @connected << c
        end
      rescue Exception => ex
        disconnect
        raise
      end

      def disconnect
        super
        @connected.each do |c|
          disconnect_one(c)
        end
      end

    private

      def disconnect_one(c)
        c.disconnect rescue nil
      end

    end # class Registry
  end # class VM
end # module Gisele
