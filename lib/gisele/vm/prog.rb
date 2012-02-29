module Gisele
  class VM
    class Prog
      attr_accessor :uuid
      attr_accessor :parent
      attr_accessor :pc
      attr_accessor :wait
      attr_accessor :start

      def initialize(attrs = {})
        @uuid   = attrs[:uuid]   || nil
        @parent = attrs[:parent] || @uuid
        @pc     = attrs[:pc]     || 0
        @wait   = attrs[:wait]   || []
        @start  = attrs[:start]  || false
      end

      def to_hash
        {:uuid => uuid, :parent => parent, :pc => pc, :wait => wait, :start => start}
      end

      def merge(with)
        merged = to_hash.merge(with.to_hash){|k,v1,v2|
          if k == :wait
            v1 | v2
          else
            v2
          end
        }
        Prog.new(merged)
      end

      def dup
        super.tap do |c|
          c.wait = wait.dup
        end
      end

      def ==(other)
        other.is_a?(Prog) and (other.to_hash == to_hash)
      end
      alias :eql? :==

    end # class Prog
  end # class VM
end # module Gisele
