module Gisele
  class VM
    class Prog
      attr_accessor :puid
      attr_accessor :parent
      attr_accessor :pc
      attr_accessor :waitlist
      attr_accessor :progress
      attr_accessor :input

      def initialize(attrs = {})
        @puid     = attrs[:puid]     || nil
        @parent   = attrs[:parent]   || @puid
        @pc       = attrs[:pc]       || 0
        @waitlist = attrs[:waitlist] || {}
        @progress = attrs[:progress] || false
        @input    = attrs[:input]    || []
      end

      def to_hash
        { :puid     => puid,
          :parent   => parent,
          :pc       => pc,
          :waitlist => waitlist,
          :progress => progress,
          :input    => input }
      end

      def merge(with)
        merged = to_hash.merge(with.to_hash){|k,v1,v2|
          k == :waitlist ? v1.merge(v2) : v2
        }
        Prog.new(merged)
      end

      def dup
        super.tap do |c|
          c.waitlist = waitlist.dup
          c.input    = input.dup
        end
      end

      def ==(other)
        other.is_a?(Prog) and (other.to_hash == to_hash)
      end
      alias :eql? :==

    end # class Prog
  end # class VM
end # module Gisele
