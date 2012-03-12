module Gisele
  class VM
    class ProgList
      class Delegate < ProgList

        attr_reader :delegate

        def initialize(delegate)
          super()
          @delegate = delegate
        end

        def connect(vm)
          super
          delegate.connect(vm)
        end

        def disconnect
          super
          delegate.disconnect
        end

        def fetch(puid)
          @delegate.fetch(puid)
        end

        def save(prog)
          @delegate.save(prog)
        end

        def pick(restriction, &bl)
          @delegate.pick(restriction, &bl)
        end

        def clear
          @delegate.clear
        end

        def to_relation(restriction = nil)
          @delegate.to_relation(restriction)
        end

      end # class Delegate
    end # class ProgList
  end # class VM
end # module Gisele
