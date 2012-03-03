module Gisele
  class VM

    # Load the Language through Sexpr
    Gvm = Sexpr.load Path.dir/"gvm/gvm.sexp.yml"

    # The Gisele bytecode language.
    module Gvm

      def instructions
        gvm = YAML.load_file (Path.dir/"gvm/gvm.sexp.yml").to_s
        gvm["rules"]["instruction"].map(&:to_sym)
      end

    end # module Gvm
  end # class VM
end # module Gisele
