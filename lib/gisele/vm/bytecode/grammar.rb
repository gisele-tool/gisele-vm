module Gisele
  class VM
    class Bytecode

      # Load the Language through Sexpr
      Grammar = Sexpr.load Path.dir/"grammar.sexp.yml"

      # The Gisele bytecode language.
      module Grammar

        def instructions
          grammar = YAML.load_file (Path.dir/"grammar.sexp.yml").to_s
          grammar["rules"]["instruction"].map(&:to_sym)
        end

      end # module Grammar
    end # class Bytecode
  end # class VM
end # module Gisele
