module Gisele
  class VM
    class Agent
      include Component

      def initialize
        @lock = Mutex.new
      end

      def connect(vm)
        super
        Thread.new{

          # The VM is still in warmup phase. We are not allowed
          # to make any request to the kernel during that phase...
          sleep(0.01) while vm.warmup?

          # We run until the vm disconnects us
          while connected?
            success = @lock.synchronize{ runone }

            # failure might be due to the shutdown process. In that
            # case, sleep a bit so as to favor disconnecting...
            sleep(0.1) unless success
          end
        }
      end

      def disconnect
        # The lock must be acquired in order to disconnect the agent.
        # This way, we ensure that a given run works completely.
        @lock.synchronize{ super }
      end

    end # class Agent
  end # class VM
end # module Gisele
