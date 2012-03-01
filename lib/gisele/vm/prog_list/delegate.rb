module Gisele
  class VM
    class ProgList
      class Delegate

        def initialize(delegate = ProgList.new)
          @delegate = delegate
        end

        def fetch(puid)
          @delegate.fetch(puid)
        end

        def save(prog)
          @delegate.save(prog)
        end

        def pick
          @delegate.pick
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
