require_relative 'prog_list/delegate'
require_relative 'prog_list/threadsafe'
require_relative 'prog_list/memory'
require_relative 'prog_list/end_of_file'
module Gisele
  class VM
    class ProgList

      def self.new(*args)
        raise "ProgList is an abstract class" if self == ProgList
        super
      end

      def self.memory(progs = [])
        ProgList::Memory.new(progs)
      end

      def self.end_of_file(file, truncate = false)
        ProgList::EndOfFile.new(file, truncate)
      end

      def release
      end

      def threadsafe
        Threadsafe.new(self)
      end

    end # class ProgList
  end # class VM
end # module Gisele
