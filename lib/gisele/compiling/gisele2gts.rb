module Gisele
  module Compiling
    class Gisele2Gts < Sexpr::Rewriter
      grammar Language

      def self.compile(arg, parse_options = {})
        case arg
        when String, Path then compile(Gisele.sexpr(Gisele.parse(arg, parse_options)))
        else
          compiler = new
          compiler.call(arg)
          compiler.gts
        end
      end

      # if/elsif/else -> guarded commands
      use Language::IfToCase

      def on_unit_def(sexpr)
        entry = add_state(:event, :initial => true)
        exit  = add_state(:end)
        tasks = sexpr.sexpr_body.select{|n| n.first == :task_def}
        tasks.each do |task|
          c_entry, c_exit = apply(task)
          connect(entry, c_entry, task[1].to_sym)
          connect(c_exit, exit)
        end
        [entry, exit]
      end

      def on_task_def(sexpr)
        entry  = add_state(:event)
        exit   = add_state(:end)
        endevt = add_state(:event)

        c_entry, c_exit = apply(sexpr.last)
        connect(entry, c_entry, start_event(sexpr))
        connect(c_exit, endevt)
        connect(endevt, exit, end_event(sexpr))

        [entry, exit]
      end

      def on_seq_st(sexpr)
        entry = add_state(:nop)
        exit  = add_state(:nop)

        current = entry
        sexpr.sexpr_body.each do |child|
          c_entry, c_exit = apply(child)
          connect(current, c_entry)
          current = c_exit
        end
        connect(current, exit)

        [entry, exit]
      end

      def on_par_st(sexpr)
        entry = add_state(:fork)
        exit  = add_state(:join)
        connect(entry, exit, :"(wait)")

        sexpr.sexpr_body.each_with_index do |child,idx|
          c_entry, c_exit = apply(child)
          c_end = add_state(:end)
          connect(entry,  c_entry, :"(forked##{idx})")
          connect(c_exit, c_end, :"(joined)")
          connect(c_end, exit,  :"(notify)")
        end

        [entry,exit]
      end

      def on_task_call_st(sexpr)
        entry = add_state(:fork)
        exit  = add_state(:join)
        connect(entry, exit, :"(wait)")

        c_entry, c_exit = task_nodes(sexpr)
        connect(entry, c_entry, :"(forked)")
        connect(c_exit, exit, :"(notify)")

        [entry, exit]
      end

      def gts
        options[:gts] ||= VM::Gts.new
      end

    private

      def task_nodes(sexpr)
        entry  = add_state(:event)
        listen = add_state(:listen)
        endevt = add_state(:event)
        exit   = add_state(:end)

        connect(entry, listen, start_event(sexpr))
        connect(listen, endevt, :ended)
        connect(endevt, exit, end_event(sexpr))

        [ entry, exit ]
      end

      def start_event(sexpr)
        {:symbol => :start, :event_args => [ sexpr[1] ]}
      end

      def end_event(sexpr)
        {:symbol => :end, :event_args => [ sexpr[1] ]}
      end

      def add_state(kind = :nop, attrs = {})
        attrs = attrs.merge(:kind => kind)
        case kind
        when :join, :end, :listen
          attrs[:accepting] = true
        end
        gts.add_state(attrs)
      end

      def connect(source, target, attrs={})
        attrs = {:symbol => attrs} if Symbol===attrs
        gts.connect(source, target, {:symbol => nil}.merge(attrs))
      end

    end # class Gisele2Gts
  end # module Compiling
end # module Gisele
