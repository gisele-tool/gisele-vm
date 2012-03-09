require 'thread'
module Gisele
  class VM
    class ProgList
      class Threadsafe < ProgList::Delegate

        def initialize(delegate)
          super(delegate)
          @lock = Mutex.new
          @cv   = ConditionVariable.new
        end

        def disconnect
          @lock.synchronize do
            super
            @cv.broadcast
          end
        end

        def fetch(puid)
          @lock.synchronize do
            super
          end
        end

        def save(prog)
          @lock.synchronize do
            super.tap{ @cv.broadcast }
          end
        end

        def pick(waitfor, &bl)
          @lock.synchronize do
            prog = nil
            while connected? and !(prog = super)
              bl.call if bl
              @cv.wait(@lock)
            end
            prog
          end
        end

        def empty?
          @lock.synchronize do
            super
          end
        end

        def to_relation
          @lock.synchronize do
            super
          end
        end

        def threadsafe
          self
        end

      end # class Threadsafe
    end # class ProgList
  end # class VM
end # module Gisele
