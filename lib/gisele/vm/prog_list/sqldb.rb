require 'sequel'
module Gisele
  class VM
    class ProgList
      class Sqldb < ProgList

        attr_reader :sequel_db

        def initialize(options = {})
          super()
          @options = default_options.merge(options)
        end

        def default_options
          { :table_name => :gvm_proglist }
        end

        def connect(vm)
          super
          @sequel_db = Sequel.connect(connection_info)
          @sequel_db.test_connection
          ensure_schema(@sequel_db)
          self
        end

        def disconnect
          super
          @sequel_db.disconnect if @sequel_db
        end

        def fetch(puid)
          got = sequel_db[table_name].
            where(:puid => puid).first
          decode(got)
        end

        def pick(restriction)
          c = sequel_db[table_name].
            where(encode(restriction)).limit(1).first
          c ? Prog.new(c) : nil
        end

        def clear
          sequel_db[table_name].delete
        end

        def to_relation(restriction = nil)
          tuples = sequel_db[table_name]
          tuples = tuples.where(encode(restriction)) if restriction
          Alf::Relation(tuples)
        end

      private

        def save_prog(prog)
          sequel_db[table_name].
            where(:puid => prog.puid).
            update(encode(prog))
          prog.puid
        end

        def register_prog(prog)
          puid = sequel_db[table_name].
            insert(encode(prog))
          sequel_db[table_name].
            where(:puid => puid).
            update(:root => puid, :parent => puid)
          puid
        end

        def decode(h)
          h[:pc]       = h[:pc].to_sym               if h.has_key?(:pc)
          h[:waitfor]  = h[:waitfor].to_sym          if h.has_key?(:waitfor)
          h[:waitlist] = ::Kernel.eval(h[:waitlist]) if h.has_key?(:waitlist)
          h[:input]    = ::Kernel.eval(h[:input])    if h.has_key?(:input)
          Prog.new(h)
        end

        def encode(prog)
          h = prog.to_hash
          h[:pc]       = h[:pc].to_s                 if h.has_key?(:pc)
          h[:waitfor]  = h[:waitfor].to_s            if h.has_key?(:waitfor)
          h[:waitlist] = h[:waitlist].inspect        if h.has_key?(:waitlist)
          h[:input]    = h[:input].inspect           if h.has_key?(:input)
          h
        end

      private

        def connection_info
          @options[:connection_info] || @options[:uri]
        end

        def table_name
          @options[:table_name]
        end

        def ensure_schema(db)
          return if db.table_exists?(tn = table_name)
          db.create_table(tn) do
            primary_key :puid
            Integer     :parent
            Integer     :root
            String      :pc
            String      :waitfor
            String      :waitlist
            String      :input
            index       :root
            index       :waitfor
          end
        end

      end # class Sqldb
    end # class ProgList
  end # class VM
end # module Gisele
