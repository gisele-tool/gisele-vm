module Gisele
  class VM
    class Agent

      attr_reader   :bytecode
      attr_reader   :proglist
      attr_accessor :event_interface

      def initialize(bytecode, proglist = nil, event_interface = nil)
        @bytecode        = load(bytecode)
        @proglist        = proglist || ProgList.memory.threadsafe
        @event_interface = event_interface
      end

      def start(label)
        vm.run(:start, [ label ])
      end

      def run
        vm.run(:run, [ ])
      end

      def resume(puid)
        vm.run(:resume, [ puid ])
      end

      def dump
        @proglist.to_relation
      end

    private

      def load(bytecode)
        bytecode = Gvm.bytecode(bytecode) unless Hash===bytecode
        bytecode.merge!(kernel)
        bytecode
      end

      def kernel
        @kernel ||= Gvm.bytecode(Path.dir/'kernel.gvm')
      end

      def vm
        VM.new nil, @bytecode, @proglist, @event_interface
      end

    end # class Agent
  end # class VM
end # module Gisele
