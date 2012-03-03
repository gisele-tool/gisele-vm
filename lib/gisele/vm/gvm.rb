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

      def self.bytecode(arg)
        body, h = sexpr(arg).sexpr_body, Hash.new
        body.each do |block|
          h[block[1]] = block[2..-1]
        end
        h
      end

    end # module Gvm
  end # class VM
end # module Gisele
