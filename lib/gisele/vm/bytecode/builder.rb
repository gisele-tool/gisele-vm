module Gisele
  class VM
    class Bytecode
      class Builder

        attr_reader :namespace

        def initialize(namespace = nil)
          @namespace     = namespace
          @bytecode      = [:gvm]
          @current_block = nil
        end

        def current_block
          unless @current_block
            raise BadUsageError, "Bytecode builder misused: no current block"
          end
          @current_block
        end

        def at(label)
          @current_block = [:block, label(label)]
          yield(self)
          @bytecode << @current_block
          bl, @current_block = @current_block, nil
          bl
        end

        def to_a
          @bytecode
        end

        Gvm.instructions.each do |iname|
          rule = Gvm[iname]
          define_method(iname) do |*args|
            instr = [iname] + args
            unless rule === instr
              raise InvalidBytecodeError, "Invalid instruction: #{instr.inspect}"
            end
            current_block << instr
            instr
          end
        end

      private

        def label(at)
          (namespace ? "#{namespace}_#{at}" : "#{at}").to_sym
        end

      end # class Builder
    end # class Bytecode
  end # class VM
end # module Gisele
