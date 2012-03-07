module Gisele
  class VM
    class EventManager

      def call(event)
        puts event.to_s
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
