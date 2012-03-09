module Gisele
  class VM
    class ProgList
      class Memory < ProgList

        def initialize(progs = [])
          @progs = progs
        end

        def fetch(puid)
          @progs[is_a_valid_puid!(puid)].dup
        end

        def save(prog)
          if Array===prog
            prog.map{|p| save(p)}
          else
            prog = is_a_prog!(prog)
            prog.puid ? save_prog(prog) : register_prog(prog)
          end
        end

        def pick(waitfor, &bl)
          candidate = @progs.select{|p| p.waitfor == waitfor}.sample
          bl.call if bl and candidate.nil?
          candidate
        end

        def empty?
          @progs.empty?
        end

        def to_relation
          Alf::Relation(@progs.map{|p| p.to_hash})
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
          }
          @progs.last.puid
        end

        def is_a_prog!(prog)
          raise ArgumentError, "Invalid prog: #{prog}", caller unless Prog===prog
          prog
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
