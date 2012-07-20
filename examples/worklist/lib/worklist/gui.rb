module Worklist
  class Gui < Sinatra::Base

    set :public_folder, Path.dir/'public'

    def agent
      settings.agent
    end

    def db
      agent.db
    end

    get '/events', provides: 'text/event-stream' do
      stream :keep_open do |out|
        agent.listeners << out
        out.callback { agent.listeners.delete(out) }
      end
    end

    get '/' do
      send_file Path.dir/'public/index.html'
    end

    get '/processes.json' do
      content_type 'application/json', :charset => 'utf-8'
      JSON::dump :tasklist => db[:tasklist].to_a
    end

    post '/start-process' do
      patient = {
        :first_name => params['first_name'],
        :last_name  => params['last_name'],
        :process    => params['process']
      }
      agent.start_process(patient)
      'ok'
    end

    post '/close-task' do
      task = { :id => params['id'] }
      agent.close_task(task)
      'ok'
    end

    COLORS = {
      "Consultation"   => "#CCFFE9",
      "Treatment"      => "#CCFF33",
      "Endoscopy"      => "#00CCFF",
      "Biopsy"         => "#FFCC00",
      "Chemotherapy"   => "#CC6600",
      "Surgery"        => "#FF99FF",
    }

    get '/css/style.css' do
      content_type 'text/css', :charset => 'utf-8'
      res = COLORS.map{|task,color|
        "table.table tr.#{task} td.id { background: #{color}; }"
      }.join("\n")
    end

    get '/process.gif' do
      content_type 'image/gif'
      dot = nil
      Path.tempfile do |tmp|
        ast   = Gisele.ast(agent.process_file)
        graph = Gisele::Compiling::ToGraph.call(ast).first
        graph.vertices.each do |vertex|
          if col = COLORS[vertex[:label]]
            vertex["style"] = "filled"
            vertex["fillcolor"] = col
          end
        end
        tmp.write graph.to_dot
        dot = `dot -Tgif #{tmp}`
      end
      dot
    end

  end # class Gui
end # module Worklist
