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
        when Bytecode     then arg
        when Path, String then parse(arg)
        when Gvm          then Bytecode.new(arg)
        else
          raise InvalidBytecodeError, "Invalid bytecode: #{arg}"
        end
      end

      def self.kernel
        Bytecode.parse(Path.dir/'kernel.gvm')
      end

      def self.builder(namespace = nil)
        Builder.new(namespace)
      end

      def self.build(namespace = nil)
        builder = builder(namespace)
        yield(builder)
        Bytecode.new(builder.to_a)
      end

      def self.parse(source)
        Bytecode.new(Gvm.sexpr(source))
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

    end # class Bytecode
  end # class VM
end # module Gisele

