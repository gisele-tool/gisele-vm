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

      def bytecode_equivalent!(other)
        raise "Not DFA equivalent" unless equivalent?(other, nil, :equiv)
        same_state_data = lambda{|mine, other|
          unless mine.data.dup.tap{|d| d.delete(:equiv)} == other.data
            raise "#{raw_data} != #{other.data} (#{mine.index}, #{other.index})"
          end
          true
        }
        same_edge_data = lambda{|mine,other|
          m_edges =  mine.out_edges.sort{|e1,e2| e1.target[:equiv] <=> e2.target[:equiv] }
          o_edges = other.out_edges.sort{|e1,e2| e1.target.index   <=> e2.target.index   }
          m_edges.zip(o_edges) do |e1,e2|
            unless e1.data == e2.data
              raise "#{e1.data.inspect} != #{e2.data.inspect} (#{e1.index}, #{e2.index})"
            end
          end
          true
        }
        states.all? do |s|
          equiv = other.ith_state(s[:equiv])
          same_state_data[s, equiv] && same_edge_data[s, equiv]
        end
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
