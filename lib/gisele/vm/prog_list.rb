module Gisele
  class VM
    class ProgList < Component
      extend Forwardable

      def initialize(storage)
        super()
        @storage = storage
        @waiting = ConditionVariable.new
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
        synchronize do
          super
          @storage.disconnect
          @waiting.broadcast
        end
      end

      def_delegators :"@storage", :options

      def fetch(puid)
        connected!
        @storage.fetch(puid)
      end

      def save(prog)
        connected!
        synchronize do
          @storage.save(prog).tap do
            @waiting.broadcast
          end
        end
      end

      def pick(restriction, &bl)
        synchronize do
          prog = nil
          while connected? && (prog = @storage.pick(restriction)).nil?
            bl.call if bl
            @waiting.wait(lock)
          end
          prog
        end
      end

      def clear
        connected!
        synchronize do
          @storage.clear
          @waiting.broadcast
        end
      end

      def to_relation(restriction = nil)
        connected!
        @storage.to_relation(restriction)
      end

    end # class ProgList
  end # class VM
end # module Gisele
require_relative 'prog_list/storage'
require_relative 'prog_list/memory'
require_relative 'prog_list/sqldb'
