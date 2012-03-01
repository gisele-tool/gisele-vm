module Gisele
  class VM
    #
    # The Gisele Virtual Machine
    #
    # SYNOPSIS
    #   gvm [--version] [--help]
    #   gvm GVM_FILE [PUID]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Command <  Quickl::Command(__FILE__, __LINE__)

      # Install options
      options do |opt|
        @mode = nil
        opt.on('-i', '--interactive', 'Start the interactive mode') do
          @mode = :interactive
        end
        @truncate = false
        opt.on('-t', '--truncate', 'Truncate process instances first') do
          @truncate = true
        end
        opt.on_tail('--help', "Show this help message") do
          raise Quickl::Help
        end
        opt.on_tail('--version', 'Show version and exit') do
          raise Quickl::Exit, "gvm #{Gisele::VM::VERSION} (c) The University of Louvain"
        end
      end

      def execute(args)
        raise Quickl::Help unless [1,2].include? args.size

        # find the .gvm file and parse it
        unless (file = Path(args.shift)).exist?
          raise Quickl::IOAccessError, "File does not exists: #{file}"
        end

        list  = ProgList.end_of_file(file, @truncate).threadsafe
        agent = VM::Agent.new(file, list)

        case @mode
        when :interactive then start_interactive(agent)
        else
          puts "You didn't specify a mode."
        end
      end

    private

      def start_interactive(agent)
        require_relative 'command/interactive'
        Interactive.new(agent).run!
      end

    end # class Command
  end # class VM
end # module Gisele
