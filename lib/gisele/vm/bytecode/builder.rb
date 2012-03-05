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

        def at(label = nil, auto=true)
          raise BadUsageError, "Previous block not dumped." if @current_block
          if label
            label = label(label) if auto
          else
            label = (namespace || "main").to_s.to_sym
          end
          @current_block = [:block, label]
          if block_given?
            yield(self)
            end_block
          end
        end

        def end_block
          bl, @current_block = @current_block, nil
          @bytecode << bl
          bl
        end

        def instruction(which, args)
          instr = [which] + args
          if Grammar[which] === instr
            current_block << instr
            instr
          else
            raise InvalidBytecodeError, "Invalid instruction: #{instr.inspect}"
          end
        end

        def to_a
          @bytecode
        end

        Grammar.instructions.each do |iname|
          define_method(iname) do |*args|
            instruction(iname, args)
          end
        end

        [ :then, :fork ].each do |iname|
          define_method(iname) do |label=nil, auto=true|
            label = label(label) if label and auto
            instruction(iname, label ? [ label ] : [ ])
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
