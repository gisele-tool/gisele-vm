module Gisele
  class VM
    class Event < Struct.new(:prog, :type, :args)

      def to_s
        "#{type}[#{prog.puid}](#{args.join(', ')})"
      end

    end # class Event
  end # class VM
end # module Gisele
