module Gisele
  class VM
    class ProgList

      def initialize
        @progs = []
      end

      def register(prog)
        @progs << is_a_prog!(prog).dup.tap{|d| d.uuid = @progs.size }
        @progs.last.uuid
      end

      def fetch(uuid)
        @progs[is_a_valid_uuid!(uuid)].dup
      end

      def save(prog)
        is_a_prog!(prog).uuid.tap{|uuid|
          @progs[is_a_valid_uuid!(uuid)] = prog.dup
        }
      end

      def to_relation
        Alf::Relation(@progs.map{|p| p.to_hash})
      end

    private

      def is_a_prog!(prog)
        raise ArgumentError, "Invalid prog: #{prog}", caller unless Prog===prog
        prog
      end

      def is_a_valid_uuid!(uuid)
        case uuid
        when Integer
          raise InvalidUUIDError, "Invalid uuid: #{uuid}" unless valid_uuid?(uuid)
          uuid
        when /^\d+$/
          is_a_valid_uuid! Integer(uuid)
        else
          raise ArgumentError, "Not an UUID: #{uuid}"
        end
      end

      def valid_uuid?(uuid)
        (Integer===uuid) and (0 <= uuid) and (uuid < @progs.size)
      end

    end # class ProgList
  end # class VM
end # module Gisele