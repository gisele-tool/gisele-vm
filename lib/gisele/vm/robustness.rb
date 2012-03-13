module Gisele
  class VM
    module Robustness

    private

      def valid_label!(at)
        unless vm.bytecode[at]
          raise InvalidLabelError, "Unknown label: `#{at.inspect}`"
        end
        at
      end

      def valid_input!(input)
        unless Array===input
          raise InvalidInputError, "Invalid VM input: `#{input.inspect}`"
        end
        input
      end

      def valid_prog!(p, waitfor)
        prog = Prog===p ? p : vm.fetch(p)
        unless prog.waitfor == waitfor
          raise InvalidStateError, "Prog `#{p}` does not wait for the #{waitfor}"
        end
        prog
      end

    end # module Robustness
  end # class VM
end # module Gisele
