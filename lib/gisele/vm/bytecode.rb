require_relative 'bytecode/source'
require_relative 'bytecode/builder'
require_relative 'bytecode/compiler'
require_relative 'bytecode/printer'
module Gisele
  class VM
    class Bytecode

      def initialize(sexpr)
        @sexpr = sexpr
      end

      def self.coerce(arg)
        case arg
        when Bytecode           then arg
        when String             then gvm(arg)
        when Stamina::Automaton then gts(arg)
        when Path
          case arg.extname
          when ".gvm"     then gvm(arg)
          when ".gts"     then gts(arg)
          when ".adl"     then adl(arg)
          end
        when Gvm                then Bytecode.new(arg)
        else
          raise ArgumentError
        end
      rescue Stamina::StaminaError, ArgumentError => ex
        msg = "Invalid bytecode source: #{arg}"
        msg << " (#{ex.message})" if ex.message
        raise InvalidBytecodeError, msg
      end
      extend Source

      def self.parse(source)
        gvm(source)
      end

      def self.kernel
        @kernel ||= Bytecode.parse(Path.dir/'kernel.gvm')
      end

      def self.builder(namespace = nil)
        Builder.new(namespace)
      end

      def self.build(namespace = nil)
        builder = builder(namespace)
        yield(builder)
        Bytecode.new(builder.to_a)
      end

      def +(other)
        other = Bytecode.coerce(other)
        Bytecode.new [:gvm] + to_a[1..-1] + other.to_a[1..-1]
      end

      def [](label)
        block = index[label]
        block ? block[2..-1] : nil
      end
      alias :fetch :[]

      def to_a
        @sexpr
      end

      def to_s
        Printer.call(to_a)
      end

    private

      def index
        @index ||= begin
          index = Hash.new
          to_a.each_with_index do |bl,i|
            next if i==0
            index[bl[1]] = bl
          end
          index
        end
      end

      # Force loading the kernel as it might take time.
      Bytecode.kernel
    end # class Bytecode
  end # class VM
end # module Gisele

