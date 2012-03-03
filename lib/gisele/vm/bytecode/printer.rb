module Gisele
  class VM
    class Bytecode
      class Printer < Sexpr::Rewriter

        def on_gvm(sexpr)
          z, *blocks = sexpr
          max = blocks.inject(0){|m,bl|
            length = bl[1].to_s.size
            length > m ? length : m
          }
          @sep = "\n" + " "*(max + 2)
          code = ""
          code << blocks.map{|bl| apply(bl)}.join("\n")
          code << "\n"
        end

        def on_block(sexpr)
          z, label, *instr = sexpr
          label = "#{label}: "
          label << " "*(@sep.size - label.size - 1)
          label << instr.map{|i| apply(i)}.join(@sep).strip
        end

        def on_missing(sexpr)
          iname, *args = sexpr
          label = "#{iname} "
          label << args.map{|arg| arg.inspect}.join(', ')
          label.strip
        end

      end # class Printer
    end # class Bytecode
  end # class VM
end # class Gisele
