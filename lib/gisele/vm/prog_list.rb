module Gisele
  class VM
    class ProgList < Component

      def self.new(*args)
        raise "ProgList is an abstract class" if self == ProgList
        super
      end

      def initialize
        super
      end

      def self.memory(progs = [])
        ProgList::Memory.new(progs)
      end

      def self.sqldb(options)
        ProgList::Sqldb.new(options)
      end

      def self.end_of_file(file, truncate = false)
        ProgList::EndOfFile.new(file, truncate)
      end

      def threadsafe
        Threadsafe.new(self)
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

    end # class ProgList
  end # class VM
end # module Gisele
require_relative 'prog_list/delegate'
require_relative 'prog_list/threadsafe'
require_relative 'prog_list/memory'
require_relative 'prog_list/end_of_file'
require_relative 'prog_list/sqldb'

