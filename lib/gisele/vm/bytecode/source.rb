module Gisele
  class VM
    class Bytecode
      module Source

      private

        def gis(source)
          sexpr = Gisele.sexpr(source)
          gts   = Stamina::Automaton.new
          Compiling::Gisele2Gts.new(:gts => gts).call(sexpr)
          puts gts.to_dot{|elm,kind|
            case kind
            when :automaton then {:rankdir => "LR"}
            when :state     then {:label  => elm[:kind]}
            when :edge      then {:label  => elm.symbol.to_s}
            end
          }
          Compiling::Gts2Bytecode.call(gts)
        end

        def gvm(source)
          Bytecode.new(Grammar.sexpr(source))
        end

        def gts(arg)
          case arg
          when Path
            fa = Kernel::eval(arg.read, TOPLEVEL_BINDING, arg.to_s)
            raise ArgumentError unless Stamina::Automaton===fa
            gts(fa)
          when Stamina::Automaton
            arg.states.each{|s| s[:kind] = Compiling::Gts2Bytecode.infer_state_kind(s) }
            arg.edges.each {|e| e.symbol = e.symbol.to_sym if e.symbol  }
            Compiling::Gts2Bytecode.call arg
          else
            raise ArgumentError
          end
        end

        def adl(arg)
          case arg
          when Path
            gts Stamina::ADL.parse_automaton_file(arg.to_s)
          when Stamina::Automaton
            gts arg
          else
            raise ArgumentError
          end
        end

      end
    end
  end
end
