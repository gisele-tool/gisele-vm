module Gisele
  class VM
    module Lifecycle

      attr_reader :status
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

        @last_error = nil
        @status     = :warmup
        info('VM start request received, connecting.')

        starter = lambda{
          begin
            registry.connect
          rescue Exception => ex
            fatal("Components failed to load: #{ex.message}") rescue nil
            @last_error = ex
            @status     = :stopped
          end
          info('Gisele VM has taken stage!')
          @status = :running
        }

        if EM.reactor_running?
          starter.call
          EM.reactor_thread.join
        else
          EM::run &starter
        end
      end

      def stop
        raise InvalidStateError, "VM not running" unless running?
        @status = :shutdown
        info('VM stop request received, disconnecting.')
        begin
          registry.disconnect
        rescue Exception => ex
          warn("Error when disconnecting: #{ex.message}") rescue nil
        end
        EM.stop_event_loop
        @status = :stopped
        info('VM stopped successfully.')
      end

    private

      def init_lifecycle
        @status = :stopped
      end

    end # module Lifecycle
  end # class VM
end # module Gisele
