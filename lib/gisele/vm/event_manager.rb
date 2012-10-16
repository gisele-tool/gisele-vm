module Gisele
  class VM
    class EventManager < Component

      def initialize
        super()
        @listeners = []
      end

      def connect
        super
        @channel, @names = EM::Channel.new, {}
        @listeners.each do |l|
          em_subscribe(l)
        end
      end

      def disconnect
        super
        @listeners.each do |l|
          em_unsubscribe(l)
        end
        @channel = @names = nil
      end

      def subscribe(a = nil, &b)
        @listeners << (a || b)
        em_subscribe(@listeners.last) if connected?
      end

      def unsubscribe(l)
        if @listeners.delete(l) and connected?
          em_unsubscribe(l)
        end
      end

      def subscribed?(l)
        @listeners.include?(l)
      end

      def event(event)
        debug(event.to_s)
        @channel.push(event) if connected?
      rescue Exception => ex
        error error_message(ex, "Error when processing `#{event.to_s}`")
      end

    private

      def name_of(l)
        @names[l]
      end

      def em_subscribe(l)
        @names[l] = @channel.subscribe(l)
      end

      def em_unsubscribe(l)
        @channel.unsubscribe(@names[l])
        @names.delete(l)
      end

    end # class EventManager
  end # class VM
end # module Gisele
