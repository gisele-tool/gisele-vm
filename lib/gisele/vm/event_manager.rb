module Gisele
  class VM
    class EventManager < Component

      def initialize(&proc)
        super()
        @proc = proc
      end

      def event(event)
        if @proc
          @proc.call(event)
        else
          info(event.to_s)
        end
      rescue Exception => ex
        msg  = "Error when processing `#{event.to_s}`\n\t#{ex.message}\n"
        msg += ex.backtrace.join("\n")
        warn(msg)  rescue nil
      end

    end # class EventManager
  end # class VM
end # module Gisele
