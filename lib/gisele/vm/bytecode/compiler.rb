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

        def compile(ts)
          builder.at do |b|
            b.then label(ts.initial_state)
          end
          ts.each_state do |s|
            send "on_#{s[:kind]}", s
          end
          Bytecode.coerce(builder.to_a)
        end

        def on_event(state)
          unless state.out_edges.size == 1
            raise ArgumentError, "Invalid :event state"
          end
          edge = state.out_edges.first
          at(state) do |b|
            b.cont label(edge.target)
            b.save
            b.push  []
            b.event edge.symbol
          end
        end

        def on_listen(state)
          h = {}
          state.out_edges.each do |edge|
            h[edge.symbol] = label(edge.target)
          end
          at(state) do |b|
            b.push h    # push the transition system on the stack
            b.flip      # [ event, {...} ] -> [ {...}, event ]
            b.get       # lookup target state
            b.skipnil   # do nothing if no such event
            b.cont      # mark continuation at that state
            b.save
          end
        end

        def on_end(state)
          unless state.out_edges.size == 0
            raise ArgumentError, "Invalid :end state"
          end
          at(state) do |b|
            b.end
            b.save
          end
        end

      private

        def at(state, &bl)
          builder.at(label(state), &bl)
        end

        def label(state)
          Symbol===state ? state : "s#{state.index}".to_sym
        end

      end # class Compiler
    end # class Bytecode
  end # class VM
end # module Gisele
