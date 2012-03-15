module Worklist
  class Agent < Gisele::VM::Component

    attr_reader :db
    attr_reader :process_file

    def initialize(process_file)
      @process_file = process_file
    end

    def connect
      super

      info("Checking Worklist database.")
      @db = ensure_schema(Sequel.connect("sqlite://#{Path.pwd}/worklist.db"))

      info("Starting Thin webserver")
      Gui.set :agent, self
      Thin::Server.start('0.0.0.0', 3000, Rack::CommonLogger.new(Gui.new), :signals => false)
    end

    def disconnect
      super
      info("Disconnecting Worklist database.")
      @db.disconnect
    end

    def listeners
      @listeners ||= []
    end

    def start_process(data)
      # Start on the VM
      puid = vm.start(:main, [ data[:process].to_sym ])

      # Build the process tuple
      tuple = data.merge(:id => puid)
      db[:processes].insert(tuple)
    end

    def close_task(data)
      vm.resume(data[:id], [ :ended ])
    end

    def event(event)
      prog, kind, task = event.prog, event.type, event.args.first
      case kind
      when :start
        tuple = {
          :id         => prog.puid,
          :process    => prog.root,
          :task       => task,
          :started_at => Time.now
        }
        db[:tasks].insert(tuple)
      when :end
        db[:tasks].where(:id => prog.puid).update(:ended_at => Time.now)
      else
        warn("Unexpected event kind #{kind}")
      end
      listeners.each do |out|
        out << "data: changed\n\n" rescue nil
      end
    end

  private

    def ensure_schema(db)
      db.create_table :processes do
        Integer :id
        String  :first_name
        String  :last_name
        String  :process
      end unless db.table_exists?(:processes)
      db.create_table :tasks do
        Integer :id
        Integer :process
        String  :task
        Time    :started_at
        Time    :ended_at
      end unless db.table_exists?(:tasks)
      unless db.table_exists?(:tasklist)
        db.create_view :tasklist, <<-SQL
          SELECT T.id as task_id,
                 first_name,
                 last_name,
                 P.process as process,
                 task,
                 started_at
            FROM tasks as T join processes as P on T.process=P.id
           WHERE T.id != P.id
             AND T.ended_at IS NULL
           ORDER BY started_at ASC
        SQL
      end
      db
    end

  end # class Agent
end # module Worklist
