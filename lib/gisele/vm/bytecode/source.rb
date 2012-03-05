module Gisele
  class VM
    class Bytecode
      module Source

      private

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
            arg.states.each{|s| s[:kind] = Compiler.infer_state_kind(s) }
            arg.edges.each {|e| e.symbol = e.symbol.to_sym if e.symbol  }
            Compiler.compile arg
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
