module Gisele
  class VM
    class NullObject < BasicObject

      def method_missing(*args)
        self
      end

    end # class NullObject
  end # class VM
end # module Gisele
