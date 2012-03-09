module Gisele
  class VM
    class NullObject < BasicObject

      def method_missing(*args)
        self
      end

      [ :debug?, :info?, :warn?, :error?, :fatal? ].each do |meth|
        define_method(meth){ false }
      end

      def to_s
        ''
      end

    end # class NullObject
  end # class VM
end # module Gisele
