module Gisele
  class VM
    #
    # The Gisele Virtual Machine
    #
    # SYNOPSIS
    #   gvm [--version] [--help]
    #   gvm GIS_FILE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Command <  Quickl::Command(__FILE__, __LINE__)

      attr_reader :gis_file

      # Install options
      options do |opt|
        @mode = :run
        opt.on('-c', '--compile', 'Compile the input file and output the VM bytecode') do
          @mode = :compile
        end
        opt.on('-g', '--gts', 'Outputs a gisele transition system') do
          @mode = :gts
        end

        @storage = "memory"
        opt.on('--storage=URI',
               "Use the specified storage (defaults to 'memory')") do |uri|
          @storage = uri
        end

        @truncate = false
        opt.on('-t', '--truncate', 'Truncate process instances first') do
          @truncate = true
        end
        @interactive = false
        opt.on('-i', '--interactive', 'Start a console in interactive VM mode') do
          @interactive = true
        end
        @simulation = false
        opt.on('-s', '--simulate', 'Use an agent simulating the environment') do
          @simulation = true
        end

        @verbose = Logger::INFO
        opt.on('--verbose', 'Log in verbose mode') do
          @verbose = Logger::DEBUG
        end
        opt.on('--silent', 'Only show warnings and errors') do
          @verbose = Logger::WARN
        end
        @log_file = $stdout
        opt.on('--log=FILE', 'Use a specific log file') do |file|
          @log_file = file
        end

        opt.on_tail('--help', "Show this help message") do
          raise Quickl::Help
        end
        opt.on_tail('--version', 'Show version and exit') do
          raise Quickl::Exit, "gvm #{Gisele::VM::VERSION} (c) The University of Louvain"
        end
      end

      def execute(args)
        raise Quickl::Help unless args.size==1
        @gis_file = Path(args.shift)

        unless gis_file.exist?
          raise Quickl::IOAccessError, "File does not exists: #{gis_file}"
        end

        case @mode
        when :run     then start_vm
        when :compile then puts bytecode
        when :gts     then puts gts.to_dot
        end
      end

    private

      def gvm_file
        @gvm_file ||= gis_file.sub_ext(".gvm")
      end

      def gts
        @gts ||= begin
          sexpr = Gisele.sexpr(gis_file)
          compiler = Compiling::Gisele2Gts.new
          compiler.call(sexpr)
          compiler.gts
        end
      end

      def bytecode
        @bytecode ||= Compiling::Gts2Bytecode.call(gts)
      end

      def vm
        gvm_file.open("w"){|io| io << bytecode.to_s } unless gvm_file.exist?
        @vm ||= VM.new(gvm_file) do |vm|

          # Install the logger
          vm.logger       = Logger.new(@log_file)
          vm.logger.level = @verbose

          # Install the ProgList
          vm.proglist = VM::ProgList.engine(@storage)

          # Install the Enacter
          vm.register VM::Enacter.new

          if @interactive
            require_relative 'command/interactive'
            vm.register Command::Interactive.new
          end

          # Add the simulation if required
          if @simulation
            vm.register Simulator::Resumer.new
            vm.register Simulator::Starter.new
          end
        end
      end

      def start_vm
        vm.run
      rescue Interrupt
        puts "Interrupt on user request (graceful shutdown)."
        vm.stop
      rescue Exception => ex
        puts "Unable to start the Virtual Machine: #{ex.message}"
        puts ex.backtrace.join("\n")
      end

    end # class Command
  end # class VM
end # module Gisele
