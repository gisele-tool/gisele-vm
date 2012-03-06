module Gisele
  module Compiling
    class Gts2Bytecode

      attr_reader :builder

      def initialize(builder = VM::Bytecode::Builder.new)
        @builder = builder
      end

      def self.call(ts, namespace = nil)
        builder = VM::Bytecode::Builder.new(namespace)
        Gts2Bytecode.new(builder).call(ts)
      end

      def call(ts)
        builder.at do |b|
          b.then label(ts.initial_state)
        end
        ts.each_state do |s|
          send :"on_#{s[:kind]}", s
        end
        VM::Bytecode.coerce(builder.to_a)
      end

      def on_nop(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :nop state"
        end
        edge = state.out_edges.first
        at(state) do |b|
          b.then label(edge.target)
        end
      end

      def on_event(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :event state #{state.inspect}"
        end
        edge = state.out_edges.first
        at(state) do |b|
          b.then label(edge.target)
          b.then label(edge)
        end
        at(edge) do |b|
          b.push  edge[:event_args] || []
          b.event edge.symbol
        end
      end

      def on_listen(state)
        h = {}
        state.out_edges.each do |edge|
          h[edge.symbol] = label(edge.target)
        end
        at(state) do |b|
          b.push h
          b.then :listen
        end
      end

      def on_fork(state)
        join_edges = state.out_edges.select{|e| e.symbol == :"(wait)"}
        unless join_edges.size == 1
          raise ArgumentError, "Invalid :fork state"
        end
        join_state = join_edges.first.target
        targets = state.out_adjacent_states - [ join_state ]
        at(state) do |b|
          b.push label(join_state)
          b.push targets.map{|t| label(t)}
          b.then :fork
        end
      end

      def on_join(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :join state"
        end
        target = state.out_edges.first.target
        at(state) do |b|
          b.push :wake => label(target)
          b.then :join
        end
      end

      def on_end(state)
        unless state.out_edges.size <= 1
          raise ArgumentError, "Invalid :end state"
        end
        at(state) do |b|
          b.then :notify
        end
      end

    private

      def label(arg)
        case arg
        when Symbol                    then arg
        when Stamina::Automaton::State then :"s#{arg.index}"
        when Stamina::Automaton::Edge  then :"e#{arg.index}"
        else
          raise ArgumentError, "Unexpected argument: #{arg.inspect}"
        end
      end

      def at(state, &bl)
        builder.at(label(state), &bl)
      end

    end # class Gts2Bytecode
  end # module Compiling
end # module Gisele
