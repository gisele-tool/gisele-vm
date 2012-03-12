module Gisele
  class VM
    class ProgList
      class Memory < ProgList

        def initialize(progs = [])
          super()
          @progs = progs
        end

        def fetch(puid)
          @progs[is_a_valid_puid!(puid)].dup
        end

        def pick(restriction, &bl)
          keys = restriction.keys
          candidate = @progs.select{|p|
            p.to_hash(keys) == restriction
          }.sample
          bl.call if bl and candidate.nil?
          candidate
        end

        def clear
          @progs = []
        end

        def to_relation(restriction = nil)
          progs = @progs
          if restriction
            keys  = restriction.keys
            progs = progs.select{|p| p.to_hash(keys) == restriction}
          end
          progs = progs.map{|p| p.to_hash}
          Alf::Relation(progs)
        end

      private

        def save_prog(prog)
          prog.puid.tap{|puid|
            @progs[is_a_valid_puid!(puid)] = prog.dup
          }
        end

        def register_prog(prog)
          @progs << prog.dup.tap{|d|
            d.puid   = @progs.size
            d.parent = d.puid if d.parent.nil?
            d.root   = d.puid if d.root.nil?
          }
          @progs.last.puid
        end

        def is_a_valid_puid!(puid)
          case puid
          when /^\d+$/
            is_a_valid_puid! Integer(puid)
          else
            unless valid_puid?(puid)
              raise InvalidPUIDError, "Invalid puid: `#{puid.inspect}`"
            end
            puid
          end
        end

        def valid_puid?(puid)
          (Integer===puid) and (0 <= puid) and (puid < @progs.size)
        end

      end # class Memory
    end # class ProgList
  end # class VM
end # module Gisele
