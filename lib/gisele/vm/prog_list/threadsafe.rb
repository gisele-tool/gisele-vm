require 'thread'
module Gisele
  class VM
    class ProgList
      class Threadsafe < ProgList::Delegate

        def initialize(delegate)
          super(delegate)
          @cv = ConditionVariable.new
        end

        def disconnect
          synchronize do
            super
            @cv.broadcast
          end
        end

        def fetch(puid)
          synchronize do
            super
          end
        end

        def save(prog)
          synchronize do
            super.tap{ @cv.broadcast }
          end
        end

        def pick(restriction, &bl)
          synchronize do
            prog = nil
            while connected? && (prog = super).nil?
              bl.call if bl
              @cv.wait(@lock)
            end
            prog
          end
        end

        def to_relation(restriction = nil)
          synchronize do
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
