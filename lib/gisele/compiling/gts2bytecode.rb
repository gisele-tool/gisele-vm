module Gisele
  module Compiling
    class Gts2Bytecode

      attr_reader :builder

      def initialize(builder = VM::Bytecode::Builder.new)
        @builder = builder
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

      def self.call(ts, namespace = nil)
        builder = VM::Bytecode::Builder.new(namespace)
        Gts2Bytecode.new(builder).call(ts)
      end

      def call(ts)
        builder.at do |b|
          b.then "s#{ts.initial_state.index}"
        end
        ts.each_state do |s|
          send "on_#{s[:kind]}", s
        end
        VM::Bytecode.coerce(builder.to_a)
      end

      def on_nop(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :nop state"
        end
        edge = state.out_edges.first
        at(:"s#{state.index}") do |b|
          b.then :"s#{edge.target.index}"
        end
      end

      def on_event(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :event state"
        end
        edge = state.out_edges.first
        at("s#{state.index}") do |b|
          b.then :"s#{edge.target.index}"
          b.then :"e#{edge.index}"
        end
        at(:"e#{edge.index}") do |b|
          b.push  []
          b.event edge.symbol
        end
      end

      def on_listen(state)
        h = {}
        state.out_edges.each do |edge|
          h[edge.symbol] = :"s#{edge.target.index}"
        end
        at(:"s#{state.index}") do |b|
          b.push h
          b.then :listen
        end
      end

      def on_fork(state)
        targets = state.out_adjacent_states
        at(:"s#{state.index}") do |b|
          b.push :"s#{state[:join]}"
          b.push targets.map{|t| :"s#{t.index}"}
          b.then :fork
        end
      end

      def on_join(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :join state"
        end
        target = state.out_edges.first.target
        at(:"s#{state.index}") do |b|
          b.push :wake => :"s#{target.index}"
          b.then :join
        end
      end

      def on_notify(state)
        unless state.out_edges.size == 1
          raise ArgumentError, "Invalid :notify state"
        end
        at(:"s#{state.index}") do |b|
          b.then :notify
        end
      end

      def on_end(state)
        unless state.out_edges.size == 0
          raise ArgumentError, "Invalid :end state"
        end
        at(:"s#{state.index}") do |b|
          b.then :notify
        end
      end

    private

      def at(state, &bl)
        builder.at(state, &bl)
      end

    end # class Gts2Bytecode
  end # module Compiling
end # module Gisele
