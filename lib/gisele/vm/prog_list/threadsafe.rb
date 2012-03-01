require 'thread'
module Gisele
  class VM
    class ProgList
      class Threadsafe < ProgList::Delegate

        def initialize(delegate)
          super(delegate)
          @mutex    = Mutex.new
          @cv       = ConditionVariable.new
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

        def pick(&bl)
          synchronize do
            wait!(bl) while (prog = super).nil?
            prog
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
