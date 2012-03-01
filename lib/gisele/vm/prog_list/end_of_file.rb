module Gisele
  class VM
    class ProgList
      class EndOfFile < ProgList::Delegate

        def initialize(file, truncate = false)
          @file = file
          if truncate
            super(ProgList::Memory.new)
            save!
          else
            super(ProgList::Memory.new(load!))
          end
        end

        def save(prog)
          super.tap{|puid| save! }
        end

      private

      def self.find_end(file, mode = 'r')
        File.open(file, mode) do |io|
          found = false
          while (s = io.gets and not(found))
            break if found = (s =~ /^__END__/)
          end
          if found
            yield(io)
          elsif mode == 'r+'
            io << "\n__END__\n"
            yield(io)
          else
            raise "Unable to find __END__"
          end
        end
      end

      def load!
        progs = []
        EndOfFile.find_end @file, 'r+' do |io|
          while s = io.gets
            progs << Prog.new(eval(s, TOPLEVEL_BINDING)) unless s.strip.empty?
          end
        end
        progs
      end

      def save!
        EndOfFile.find_end @file, 'r+' do |io|
          io.truncate(io.pos)
          @delegate.to_relation.each do |tuple|
            io << Alf::Tools::to_ruby_literal(tuple) << "\n"
          end
        end
      end

      end # class EndOfFile
    end # class ProgList
  end # class VM
end # module Gisele
