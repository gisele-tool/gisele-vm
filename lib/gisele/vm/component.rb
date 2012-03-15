module Gisele
  class VM
    class Component
      extend Forwardable

      def initialize
        @vm        = nil
        @connected = false
      end

      def vm
        @vm || NullObject.new
      end

      def registered(vm)
        @vm = vm
      end

      def unregistered
        @vm = nil
      end

      def registered?
        !@vm.nil?
      end

      def registered!
        raise InvalidStateError, "Not registered" unless registered?
      end

      def connect
        registered!
        raise InvalidStateError, "Already connected" if connected?
        @connected = true
        info(welcome_message)
        EM.next_tick do
          info(heartbeat_in_message)
          enter_heartbeat
        end if respond_to?(:enter_heartbeat)
      end

      def disconnect
        raise InvalidStateError, "Not connected" unless connected?
        if respond_to?(:leave_heartbeat)
          info(heartbeat_out_message)
          leave_heartbeat
        end
        @connected = false
        info(goodbye_message)
      end

      def connected?
        @connected
      end

      def connected!
        raise InvalidStateError, "Not connected" unless connected?
      end

      def_delegators :vm, :debug,  :info,  :warn,  :error,  :fatal
      def_delegators :vm, :debug?, :info?, :warn?, :error?, :fatal?

    private

      def component_name
        self.class.name.to_s.split('::').last
      end

      def welcome_message
        "Component <#{component_name}> connecting."
      end

      def heartbeat_in_message
        "Component <#{component_name}> entering heartbeat."
      end

      def heartbeat_out_message
        "Component <#{component_name}> exiting heartbeat."
      end

      def goodbye_message
        "Component <#{component_name}> disconnected."
      end

      def error_message(error, base = "An error occured:")
        base.to_s << " " << error.message << "\n" << error.backtrace.join("\n")
      end

    end # class Component
  end # class VM
end # module Gisele
