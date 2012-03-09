module Gisele
  class VM
    class Agent
      include Component

      attr_reader :options
      attr_reader :thread

      def initialize(options = {})
        @lock = Mutex.new
        @options = default_options.merge(options)
      end

      def default_options
        {}
      end

      def connect(vm)
        super
        @thread = Thread.new{

          # The VM is still in warmup phase. We are not allowed to make any
          # request to the kernel during that phase...
          sleep(0.01) while vm.warmup?

          # while true loop is there
          run
        }
      end

      def disconnect
        # The lock must be acquired in order to disconnect the agent.
        # This way, we ensure that a given run works completely.
        synchronize{ super }
      end

      def run
        # We run until the vm disconnects us
        while connected?
          begin
            # run it (critical section is under child's responsibility)
            runone
          rescue Exception => ex
            fatal error_message(ex, "Agent #{self} crashed:") rescue nil
          end
        end
      end

    private

      def synchronize(&bl)
        @lock.synchronize(&bl)
      end

      def error_message(error, base = "An error occured:")
        base.to_s << " " << error.message << "\n" << error.backtrace.join("\n")
      end

    end # class Agent
  end # class VM
end # module Gisele
