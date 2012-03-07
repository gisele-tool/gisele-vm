module Gisele
  class VM
    class Event < Struct.new(:puid, :type, :args)

      def to_s
        "#{type}[#{puid}](#{args.join(', ')})"
      end

    end # class Event
  end # class VM
end # module Gisele
