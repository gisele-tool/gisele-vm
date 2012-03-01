require_relative 'prog_list/delegate'
require_relative 'prog_list/memory'
require_relative 'prog_list/end_of_file'
module Gisele
  class VM
    class ProgList

      def self.new
        Memory.new
      end

    end # class ProgList
  end # class VM
end # module Gisele
