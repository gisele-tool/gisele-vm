module Gisele
  class VM
    class ProgList

      def initialize
        @progs = []
      end

      def fetch(uuid)
        @progs[uuid].dup
      end

      def register(prog)
        prog = prog.dup.tap{|d|
          d.uuid = @progs.size
        }
        @progs << prog
        prog.uuid
      end

      def save(prog)
        @progs[prog.uuid] = prog.dup
      end

      def to_relation
        Alf::Relation(@progs.map{|p| p.to_hash})
      end

    end # class ProgList
  end # class VM
end # module Gisele