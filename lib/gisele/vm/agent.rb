module Gisele
  class VM
    class Agent
      include Component

      def initialize
        @thread = nil
        @mutex  = Mutex.new
      end

      def connect(vm)
        synchronize{ super }
        @thread = Thread.new{ run }
      end

      def disconnect
        synchronize{ super }
        @thread.join if @thread
      end

    private

      def synchronize(&bl)
        @mutex.synchronize(&bl)
      end

    end # class Agent
  end # class VM
end # module Gisele
