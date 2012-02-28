require_relative 'prog_list/memory'
module Gisele
  class VM
    class ProgList

      def self.new
        Memory.new
      end

    end # class ProgList
  end # class VM
end # module Gisele