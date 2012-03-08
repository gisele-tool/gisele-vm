module Gisele
  class VM
    module Lifecycle

      def running?
        @running
      end

      def run
        raise InvalidStateError, "VM already running" if running?
        info('VM start request received, acquiring lock...')
        synchronize do
          @running = true
          connect_components
          info('Gisele VM has taken stage!')
          yield if block_given? rescue nil
          @lock.wait(@mutex) while running?
        end
      rescue InvalidStateError
        raise
      rescue Exception
        @running = false
        raise
      end

      def run!
        raise InvalidStateError, "VM already running" if running?
        result = nil
        runner = Thread.new(self) do |vm|
          begin
            vm.run{ result = true }
          rescue Exception => ex
            result = ex
          end
        end
        sleep(0.01) while result.nil?
        Exception===result ? raise(result) : runner
      end

      def stop
        raise InvalidStateError, "VM not running" unless running?
        info('VM stop request received, acquiring lock...')
        synchronize do
          @running = false
          disconnect_components(components.reverse)
          @lock.signal
        end
        info('VM stopped successfully.')
      end

    private

      def init_lifecycle
        @mutex = Mutex.new
        @lock  = ConditionVariable.new
        @running = false
      end

      def connect_components
        connected = []
        components.each do |c|
          c.connect(self)
          connected << c
        end
      rescue Exception => ex
        disconnect_components(connected)
        raise
      end

      def disconnect_components(which = components)
        which.each{|c| c.disconnect rescue nil }
      end

      def synchronize(&bl)
        @mutex.synchronize(&bl)
      end

    end # module Lifecycle
  end # class VM
end # module Gisele
