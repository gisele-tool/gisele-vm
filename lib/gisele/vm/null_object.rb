module Gisele
  class VM
    class NullObject < BasicObject

      def method_missing(*args)
      end

    end # class NullObject
  end # class VM
end # module Gisele
