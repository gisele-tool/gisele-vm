module Gisele
  class VM
    class ProgList < Component
      extend Forwardable

      def initialize(storage)
        super()
        @storage = storage
      end

      def self.memory
        ProgList.new storage("memory")
      end

      def self.storage(options = nil)
        options = {:uri => "memory"} unless options
        options = {:uri => options } unless Hash===options
        options[:uri] = "memory" unless options[:uri]
        options[:uri] = "#{Sqldb.sqlite_protocol}:memory" if options[:uri]=='memory'
        ProgList::Sqldb.new(options)
      end

      def registered(vm)
        super
        @storage.registered(vm)
      end

      def unregistered
        super
        @storage.unregistered
      end

      def connect
        super
        @storage.connect
      end

      def disconnect
        super
        @storage.disconnect
      end

      def_delegators :"@storage", :options,
                                  :fetch,
                                  :pick,
                                  :save,
                                  :clear,
                                  :to_relation

    end # class ProgList
  end # class VM
end # module Gisele
require_relative 'prog_list/storage'
require_relative 'prog_list/memory'
require_relative 'prog_list/sqldb'
