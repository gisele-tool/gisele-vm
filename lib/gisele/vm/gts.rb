module Gisele
  class VM
    class Gts < Stamina::Automaton

      def to_dot
        dotter = lambda{|elm,kind|
          case kind
            when :automaton
              { :rankdir => "LR" }
            when :state
              { :label     => state_label(elm),
                :shape     => state_shape(elm),
                :fixedsize => "true",
                :width     => "0.6",
                :style     => "filled",
                :fillcolor => state_color(elm) }
            when :edge
              { :label => edge_label(elm) }
          end
        }
        super(&dotter)
      end

    private

      def state_label(state)
        case state[:kind]
        when :event then "EVT"
        else
          state[:kind].to_s[0, 1].capitalize
        end
      end

      def state_color(state)
        case state[:kind]
        when :end then "grey"
        else
          state.initial? ? "green" : "white"
        end
      end

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
