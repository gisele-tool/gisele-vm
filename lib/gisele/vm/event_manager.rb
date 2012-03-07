module Gisele
  class VM
    class EventManager

      def initialize(&proc)
        @proc = proc
      end

      def event(event)
        @proc.call(event) if @proc
      rescue Exception => ex
        log_error(event, ex) if logger rescue nil
      end

    private

      def log_error(event, error)
        logger.error "Error when processing `#{event.to_s}`\n\t#{error.message}"
      end

    end # class EventManager
  end # class VM
end # module Gisele
