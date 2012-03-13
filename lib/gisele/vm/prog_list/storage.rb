module Gisele
  class VM
    class ProgList
      class Storage < Component
        attr_reader :options

        def initialize(options = {})
          super()
          @options = options
        end

        def save(prog)
          if Array===prog
            prog.map{|p| save(p)}
          else
            prog = is_a_prog!(prog)
            prog.puid ? save_prog(prog) : register_prog(prog)
          end
        end

      private

        def is_a_prog!(prog)
          raise ArgumentError, "Invalid prog: #{prog}", caller unless Prog===prog
          prog
        end

      end # class Storage
    end # class ProgList
  end # class VM
end # module Gisele
