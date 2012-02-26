module Gisele
  class VM
    class Prog
      attr_accessor :uuid
      attr_accessor :parent
      attr_accessor :pc
      attr_accessor :wait

      def initialize(attrs = {})
        @uuid   = attrs[:uuid]   || nil
        @parent = attrs[:parent] || nil
        @pc     = attrs[:pc]     || 0
        @wait   = attrs[:wait]   || []
      end

      def to_hash
        {:uuid => uuid, :parent => parent, :pc => pc, :wait => wait}
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