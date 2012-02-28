module Gisele
  class VM

    # Load the Language through Sexpr
    Gvm = Sexpr.load Path.dir/"gvm/gvm.sexp.yml"

  end # class VM
end # module Gisele