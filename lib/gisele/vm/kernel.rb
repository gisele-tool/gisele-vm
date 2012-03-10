module Gisele
  class VM
    class Kernel < Component
      include Robustness

      def self.bytecode
        @kernelbc ||= Bytecode.parse(Path.dir/'kernel/macros.gvm')
      end

      def_delegators :vm, :pick,
                          :fetch,
                          :save,
                          :event

      def start(at, input)
        at    = valid_label!(at)
        input = valid_input!(input)

        runner(nil) do |k|
          stack = k.run(:start, [ input, at ])
          stack.first
        end
      end

      def resume(puid, input)
        prog  = Prog===puid ? puid : fetch(puid)
        prog  = valid_prog!(puid, :world)
        input = valid_input!(input)

        runner(prog) do |k|
          k.run(:resume, [ input ])
        end
      end

      def progress(puid)
        prog = valid_prog!(puid, :enacter)

        runner(prog) do |k|
          k.run(:progress, [ ])
        end
      end

    private

      def runner(prog = nil)
        if block_given?
          yield Runner.new(vm, prog)
        else
          Runner.new(vm, prog)
        end
      end

    end # class Kernel
  end # class VM
end # module Gisele
require_relative 'kernel/opcodes'
require_relative 'kernel/runner'

