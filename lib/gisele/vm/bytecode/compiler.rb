module Gisele
  class VM
    class Bytecode
      class Compiler

        attr_reader :builder

        def initialize(builder = Builder.new)
          @builder = builder
        end

        def self.compile(ts, namespace = nil)
          builder = Builder.new(namespace)
          Compiler.new(builder).compile(ts)
        end

        def self.infer_state_kind(state)
          if state[:kind]
            state[:kind]
          elsif state.out_edges.empty?
            :end
          elsif state.accepting?
            :listen
          else
            :event
          end
        end

        def compile(ts)
          builder.at do |b|
            b.then "entry#{ts.initial_state.index}"
          end
          ts.each_state do |s|
            send "on_#{s[:kind]}", s
          end
          Bytecode.coerce(builder.to_a)
        end

        def on_nop(state)
          unless state.out_edges.size == 1
            raise ArgumentError, "Invalid :nop state"
          end
          edge = state.out_edges.first
          at(:"entry#{state.index}") do |b|
            b.then :"entry#{edge.target.index}"
          end
        end

        def on_event(state)
          unless state.out_edges.size == 1
            raise ArgumentError, "Invalid :event state"
          end
          edge = state.out_edges.first
          at(:"entry#{state.index}") do |b|
            b.then :"state#{state.index}"
          end
          at("state#{state.index}") do |b|
            b.then :"entry#{edge.target.index}"
            b.then :"edge#{edge.index}"
          end
          at(:"edge#{edge.index}") do |b|
            b.push  []
            b.event edge.symbol
          end
        end

        def on_listen(state)
          h = {}
          state.out_edges.each do |edge|
            h[edge.symbol] = :"entry#{edge.target.index}"
          end
          at(:"entry#{state.index}") do |b|
            b.cont :"state#{state.index}"
            b.save
          end
          at("state#{state.index}") do |b|
            b.push h       # push the transition system on the stack
            b.flip         # [ event, {...} ] -> [ {...}, event ]
            b.get          # lookup target state
            b.ifenil       # if no such event...
            b.then :sleep  #   then sleep
            b.then         #   else continue there
          end
        end

        def on_fork(state)
          at(:"entry#{state.index}") do |b|
            targets = state.out_adjacent_states
            size    = targets.size
            targets.each do |target|
              b.fork :"entry#{target.index}"
            end
            b.save size
            b.wait size
            b.push :"entry#{state[:join]}"
            b.set  :pc
            b.save
          end
        end

        def on_join(state)
          at(:"entry#{state.index}") do |b|
            b.end
            b.save
            b.notify
            b.save
          end
        end

        def on_end(state)
          unless state.out_edges.size == 0
            raise ArgumentError, "Invalid :end state"
          end
          at(:"entry#{state.index}") do |b|
            b.end
            b.save
          end
        end

      private

        def at(state, &bl)
          builder.at(state, &bl)
        end

      end # class Compiler
    end # class Bytecode
  end # class VM
end # module Gisele
