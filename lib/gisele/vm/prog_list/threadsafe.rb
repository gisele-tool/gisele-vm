require 'thread'
module Gisele
  class VM
    class ProgList
      class Threadsafe < Component

        attr_reader :delegate

        def initialize(delegate)
          super()
          @delegate = delegate
          @cv       = ConditionVariable.new
        end

        def options
          @delegate.options
        end

        def connect(vm)
          super
          @delegate.connect(vm)
        end

        def disconnect
          super
          synchronize do
            @delegate.disconnect
            @cv.broadcast
          end
        end

        def fetch(puid)
          synchronize do
            @delegate.fetch(puid)
          end
        end

        def save(prog)
          synchronize do
            @delegate.save(prog).tap{ @cv.broadcast }
          end
        end

        def pick(restriction, &bl)
          synchronize do
            prog = nil
            while connected? && (prog = @delegate.pick(restriction)).nil?
              bl.call if bl
              @cv.wait(@lock)
            end
            prog
          end
        end

        def clear
          synchronize do
            @delegate.clear
          end
        end

        def to_relation(restriction = nil)
          synchronize do
            @delegate.to_relation(restriction)
          end
        end

        def threadsafe
          self
        end

      end # class Threadsafe
    end # class ProgList
  end # class VM
end # module Gisele
