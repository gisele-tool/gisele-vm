module Gisele
  class VM
    class Registry < Component

      attr_reader :components

      def initialize(vm)
        super()
        @vm         = vm
        @components = []
        @threads    = {}
      end

      def register(component, prior = false)
        raise NotImplementedError,
              "Hot registration is not implemented." if connected?
        if prior
          @components.unshift component
        else
          @components.push component
        end
        component.registered(vm)
      end

      def unregister(component)
        raise NotImplementedError,
              "Hot unregistration is not implemented." if connected?
        @components.delete(component)
        component.unregistered
      end

      def connect
        super
        @components.each do |c|
          @threads[c] = c.connect
        end
      rescue Exception => ex
        disconnect
        raise
      end

      def disconnect
        super
        @threads.each_pair do |c,t|
          begin
            c.disconnect
          rescue Exception => ex
            warn("Error when disconnecting #{c}: #{ex.message}") rescue nil
          end
        end
      end

      def join
        @threads.each_pair do |c,t|
          t.join if Thread===t
        end
      end

    end # class Registry
  end # class VM
end # module Gisele
