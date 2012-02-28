require_relative '../../gisele-vm'
module Gisele
  class VM
    #
    # The Gisele Virtual Machine
    #
    # SYNOPSIS
    #   gvm [--version] [--help]
    #   gvm GVM_FILE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Command <  Quickl::Command(__FILE__, __LINE__)

      # Install options
      options do |opt|
        opt.on_tail('--help', "Show this help message") do
          raise Quickl::Help
        end
        opt.on_tail('--version', 'Show version and exit') do
          raise Quickl::Exit, "gvm #{Gisele::VM::VERSION} (c) The University of Louvain"
        end
      end

      def execute(args)
        raise Quickl::Help unless args.size == 1

        unless (file = Path(args.first)).exist?
          raise Quickl::IOAccessError, "File does not exists: #{file}"
        end
      end

    end # class Command
  end # class VM
end # module Gisele