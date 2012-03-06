module Gisele
  class VM
    class Gts < Stamina::Automaton

      def to_dot
        dotter = lambda{|elm,kind|
          case kind
            when :automaton
              { :rankdir => "LR" }
            when :state
              { :shape     => state_shape(elm),
                :size      => "fixed",
                :width     => "0.5",
                :style     => "filled",
                :fillcolor => (elm.initial? ? "green" : "white") }
            when :edge
              { :label => edge_label(elm) }
          end
        }
        super(&dotter)
      end

    private

      def state_shape(state)
        case state[:kind]
        when :fork then "octagon"
        when :join then "doubleoctagon"
        else
          state.accepting? ? "doublecircle" : "circle"
        end
      end

      def edge_label(edge)
        if args=edge[:event_args]
          "#{edge.symbol}(#{args.join ', '})"
        else
          edge.symbol || ""
        end
      end

    end # class Gts
  end # class VM
end # module Gisele