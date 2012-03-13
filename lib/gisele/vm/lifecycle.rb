module Gisele
  class VM
    module Lifecycle

      attr_reader :status
      attr_reader :thread
      attr_reader :last_error

      def stopped?
        @status == :stopped
      end

      def running?
        @status == :running
      end

      def warmup?
        @status == :warmup
      end

      def shutdown?
        @status == :shutdown
      end

      def run
        raise InvalidStateError, "VM already running" unless stopped?
        @lock.synchronize do
          @last_error = nil
          @status     = :warmup

          info('VM start request received, connecting.')
          begin
            registry.connect
          rescue Exception => ex
            fatal("Components failed to load: #{ex.message}") rescue nil
            @last_error = ex
            @status = :stopped
            yield(@status) if block_given?
            raise
          end
          info('Gisele VM has taken stage!')

          @status = :running
          yield(@status) if block_given?
          @cv.wait(@lock) while running?
        end
      end

      def run!
        raise InvalidStateError, "VM already running" unless stopped?
        done    = false
        @thread = Thread.new(self) do |vm|
          vm.run{|s| done=true} rescue nil
        end
        Thread.pass until done
        running? ? @thread : raise(last_error)
      end

      def stop
        raise InvalidStateError, "VM not running" unless running?
        @lock.synchronize do
          @status = :shutdown

          info('VM stop request received, disconnecting.')
          begin
            registry.disconnect
          rescue Exception => ex
            warn("Error when disconnecting: #{ex.message}") rescue nil
          end
          info('VM stopped successfully.')

          @status = :stopped
          @cv.signal
        end
      end

    private

      def init_lifecycle
        @status = :stopped
        @lock   = Mutex.new
        @cv     = ConditionVariable.new
      end

    end # module Lifecycle
  end # class VM
end # module Gisele
