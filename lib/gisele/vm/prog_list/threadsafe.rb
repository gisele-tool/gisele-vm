require 'thread'
module Gisele
  class VM
    class ProgList
      class Threadsafe < ProgList::Delegate

        def initialize(delegate)
          super(delegate)
          @mutex    = Mutex.new
          @cv       = ConditionVariable.new
          @released = false
        end

        def fetch(puid)
          synchronize{ super }
        end

        def save(prog)
          synchronize do
            puid = super
            notify!
            puid
          end
        end

        def pick(waitfor, &bl)
          synchronize do
            while (prog = super).nil?
              wait!(bl)
              break if @released
            end
            prog
          end
        end

        def release
          synchronize do
            @released = true
            notify!
          end
        end

        def empty?
          synchronize{ super }
        end

        def to_relation
          synchronize{ super }
        end

        def threadsafe
          self
        end

      private

        def synchronize(&bl)
          @mutex.synchronize(&bl)
        end

        def wait!(bl)
          bl.call if bl
          @cv.wait(@mutex)
        end

        def notify!
          @cv.signal
        end

      end # class Threadsafe
    end # class ProgList
  end # class VM
end # module Gisele
