module Gisele
  class VM
    module Lifecycle

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
            # Connect the components now. This is safe: all are connected
            # or none of them (see that method)
            connect_components
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
        sleep(0.01) until done
        running? ? @thread : raise(last_error)
      end

      def stop
        raise InvalidStateError, "VM not running" unless running?
        @lock.synchronize do
          @status = :shutdown

          info('VM stop request received, disconnecting.')
          begin
            disconnect_components(components)
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

    end # module Lifecycle
  end # class VM
end # module Gisele
