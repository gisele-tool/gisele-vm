require 'thread'
module Gisele
  class VM
    class ProgList
      class Blocking < ProgList::Delegate

        def initialize(delegate = ProgList.new)
          super(delegate)
          @mutex    = Mutex.new
          @cv       = ConditionVariable.new
        end

        def save(prog)
          super.tap{|puid| _notify! }
        end

        def pick(&listener)
          _wait!(listener) while (prog = super).nil?
          prog
        end

      private

        def _wait!(listener)
          @mutex.synchronize do
            listener.call if listener
            @cv.wait(@mutex)
          end
        end

        def _notify!
          @mutex.synchronize do
            @cv.signal
          end
        end

      end # class Blocking
    end # class ProgList
  end # class VM
end # module Gisele
