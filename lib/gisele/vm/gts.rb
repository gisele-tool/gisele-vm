module Gisele
  class VM
    class Gts < Stamina::Automaton

      def to_dot
        dotter = lambda{|elm,kind|
          case kind
            when :automaton
              { :rankdir => "LR" }
            when :state
              { :shape     => (elm.accepting? ? "doublecircle" : "circle"),
                :size      => "fixed",
                :width     => "0.5",
                :style     => "filled",
                :fillcolor => (elm.initial? ? "green" : "white") }
            when :edge
              { :label => elm.symbol.to_s }
          end
        }
        super(&dotter)
      end

    end # class Gts
  end # class VM
end # module Gisele