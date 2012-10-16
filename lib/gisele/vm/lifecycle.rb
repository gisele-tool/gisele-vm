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
        if EM.reactor_running?
          starter
          EM.reactor_thread.join
        else
          EM.error_handler do |ex|
            fatal("EventMachine crashed: #{ex.message}\n" + ex.backtrace.join("\n"))
            if warmup?
              @status = :stopped
              EM.stop_event_loop
            end
          end
          EM::run &method(:starter)
        end
      end

      def stop
        raise InvalidStateError, "VM not running" unless running?
        @status = :shutdown
        info('VM stop request received, disconnecting.')
        registry.disconnect
        EM.stop_event_loop
        @status = :stopped
        info('VM stopped successfully.')
      end

    private

      def init_lifecycle
        @status = :stopped
      end

      def starter
        @last_error = nil
        @status     = :warmup
        info('VM start request received, connecting.')
        registry.connect
        info('Gisele VM has taken stage!')
        @status = :running
      rescue Exception => ex
        fatal("VM start failed.")
        @last_error = ex
        raise
      end

    end # module Lifecycle
  end # class VM
end # module Gisele
