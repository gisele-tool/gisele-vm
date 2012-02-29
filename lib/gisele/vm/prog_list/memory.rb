module Gisele
  class VM
    class ProgList
      class Memory

        def initialize(progs = [])
          @progs = progs
        end

        def register(prog)
          @progs << is_a_prog!(prog).dup.tap{|d|
            d.puid   = @progs.size
            d.parent = d.puid if d.parent.nil?
          }
          @progs.last.puid
        end

        def fetch(puid)
          @progs[is_a_valid_puid!(puid)].dup
        end

        def save(prog)
          is_a_prog!(prog).puid.tap{|puid|
            @progs[is_a_valid_puid!(puid)] = prog.dup
          }
        end

        def empty?
          @progs.empty?
        end

        def to_relation
          Alf::Relation(@progs.map{|p| p.to_hash})
        end

      private

        def is_a_prog!(prog)
          raise ArgumentError, "Invalid prog: #{prog}", caller unless Prog===prog
          prog
        end

        def is_a_valid_puid!(puid)
          case puid
          when Integer
            raise InvalidPUIDError, "Invalid puid: #{puid}" unless valid_puid?(puid)
            puid
          when /^\d+$/
            is_a_valid_puid! Integer(puid)
          else
            raise ArgumentError, "Not an PUID: #{puid}"
          end
        end

        def valid_puid?(puid)
          (Integer===puid) and (0 <= puid) and (puid < @progs.size)
        end

      end # class Memory
    end # class ProgList
  end # class VM
end # module Gisele
