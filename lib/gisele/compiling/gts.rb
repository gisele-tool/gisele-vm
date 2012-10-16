module Gisele
  module Compiling
    class Gts < Stamina::Automaton

      class Equivalence < Stamina::Automaton::Equivalence

        def equivalent_states?(s, t)
          super && (s.data == t.data)
        end

        def equivalent_edges?(e, f)
          super && (e.data == f.data)
        end
      end

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
        super(false, &dotter)
      end

      def bytecode_equivalent!(other)
        raise "Not DFA equivalent" unless Equivalence.new.call(self, other)
        true
      end

    private

      def state_label(state)
        case state[:kind]
        when :event  then "EVT"
        when :launch then "LA"
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
        s = [:fork, :join].include?(state[:kind]) ? "octagon" : "circle"
        state.accepting? ? "double#{s}" : s
      end

      def edge_label(edge)
        if args=edge[:event_args]
          "#{edge.symbol}(#{args.join ', '})"
        else
          edge.symbol || ""
        end
      end

    end # class Gts
  end # module Compiling
end # module Gisele
