module Gisele
  class VM
    module Lifecycle

      attr_reader :status
      attr_reader :thread

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

      def run(block = true)
        raise InvalidStateError, "VM already running" unless stopped?

        @lock.synchronize do
          @status     = :warmup

          info('VM start request received, connecting.')
          begin
            registry.connect
          rescue Exception => ex
            fatal("Components failed to load: #{ex.message}") rescue nil
            @status = :stopped
            yield(@status) if block_given?
            raise
          end
          info('Gisele VM has taken stage!')

          @status = :running
          yield(@status) if block_given?
        end

        @thread = Thread.new{
          registry.join
          info('VM stopped successfully.')
          @status = :stopped
        }
        @thread.join if block
      end

      def run!
        run(false)
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
        end
      end

    private

      def init_lifecycle
        @status = :stopped
        @lock   = Mutex.new
      end

    end # module Lifecycle
  end # class VM
end # module Gisele
