module Gisele
  class VM
    class ProgList
      class Delegate < ProgList

        def initialize(delegate)
          @delegate = delegate
        end

        def fetch(puid)
          @delegate.fetch(puid)
        end

        def save(prog)
          @delegate.save(prog)
        end

        def pick(&bl)
          @delegate.pick(&bl)
        end

        def empty?
          @delegate.empty?
        end

        def to_relation
          @delegate.to_relation
        end

      end # class Delegate
    end # class ProgList
  end # class VM
end # module Gisele
