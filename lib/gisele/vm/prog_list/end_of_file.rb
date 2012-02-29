module Gisele
  class VM
    class ProgList
      class EndOfFile

        def initialize(file)
          @file = file
          load!
        end

        def register(prog)
          puid = @delegate.register(prog)
          save!
          puid
        end

        def fetch(puid)
          @delegate.fetch(puid)
        end

        def save(prog)
          puid = @delegate.save(prog)
          save!
          puid
        end

        def empty?
          @delegate.empty?
        end

        def to_relation
          @delegate.to_relation
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
        @delegate = ProgList::Memory.new(progs)
      end

      def save!
        EndOfFile.find_end @file, 'r+' do |io|
          @delegate.to_relation.each do |tuple|
            io << Alf::Tools::to_ruby_literal(tuple) << "\n"
          end
        end
      end

      end # class EndOfFile
    end # class ProgList
  end # class VM
end # module Gisele
