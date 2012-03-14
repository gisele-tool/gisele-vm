module Gisele
  class VM
    #
    # The Gisele Virtual Machine
    #
    # SYNOPSIS
    #   gvm [--version] [--help]
    #   gvm [--drb-server] [options] GIS_FILE
    #   gvm --drb-client [options]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Command <  Quickl::Command(__FILE__, __LINE__)

      attr_reader :gis_file

      # Install options
      options do |opt|
        opt.on('--help', "Show this help message") do
          raise Quickl::Help
        end
        opt.on('--version', 'Show version and exit') do
          raise Quickl::Exit, "gvm #{Gisele::VM::VERSION} (c) The University of Louvain"
        end

        @mode = :run
        opt.on('-c', '--compile', 'Compile the input file and output the VM bytecode') do
          @mode = :compile
        end
        opt.on('-g', '--gts', 'Outputs a gisele transition system') do
          @mode = :gts
        end

        opt.separator("\nStorage")
        @storage = "memory"
        opt.on('--storage=URI',
               "Use the specified storage (defaults to 'memory')") do |uri|
          @storage = uri
        end
        @truncate = false
        opt.on('-t', '--truncate', 'Truncate process instances first') do
          @truncate = true
        end

        opt.separator("\nVM & Agents")
        @interactive = false
        opt.on('-i', '--interactive', 'Start a console in interactive VM mode') do
          @interactive = true
        end
        @simulation = false
        opt.on('-s', '--simulate', 'Use an agent simulating the environment') do
          @simulation = true
        end
        @drb_server = false
        opt.on('--drb-server', 'Register the VM as a DRb server') do
          @drb_server = true
        end
        @drb_client = false
        opt.on('--drb-client', 'Look for the virtual machine on DRb') do
          @drb_client = true
        end

        opt.separator("\nLogging")
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
      end

      def execute(args)
        raise Quickl::Help if args.size > 1
        @gis_file = Path(args.shift)
        case @mode
        when :run        then start_vm
        when :compile    then puts bytecode
        when :gts        then puts gts.to_dot
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

      def real_vm
        unless gvm_file.exist?
          unless gis_file && gis_file.exist?
            raise Quickl::IOAccessError, "File does not exists: #{gis_file}"
          end
          gvm_file.open("w"){|io| io << bytecode.to_s }
        end
        VM.new(gvm_file) do |vm|
          vm.proglist = VM::ProgList.new VM::ProgList.storage(@storage)
          vm.register VM::Enacter.new
          populate(vm)
        end
      end

      def drb_vm
        require_relative 'proxy'
        Proxy::Client.new{|vm|
          populate(vm)
        }
      end

      def populate(vm)
        # Install the logger
        vm.logger       = Logger.new(@log_file)
        vm.logger.level = @verbose

        # Add the simulation if required
        if @simulation
        end

        # Add the DRb server if required
        if @drb_server
          require_relative 'proxy'
          vm.register Proxy::Server.new
        end

        if @interactive
          require_relative 'command/interactive'
          vm.register Command::Interactive.new
        end
        vm
      end

      def vm
        @vm ||= @drb_client ? drb_vm : real_vm
      end

      def start_vm
        the_vm = vm
        trap('INT'){
          the_vm.info "Interrupt on user request (graceful shutdown)."
          the_vm.stop
        }
        begin
          the_vm.run
        rescue Exception => ex
          puts "Unable to start the Virtual Machine: #{ex.message}"
          puts ex.backtrace.join("\n")
        end
      end

    end # class Command
  end # class VM
end # module Gisele
