module Gisele
  class VM
    #
    # The Gisele Virtual Machine
    #
    # SYNOPSIS
    #   gvm [--version] [--help]
    #   gvm GVM_FILE [UUID]
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
        raise Quickl::Help unless [1,2].include? args.size

        # find the .gvm file and parse it
        unless (file = Path(args.shift)).exist?
          raise Quickl::IOAccessError, "File does not exists: #{file}"
        end
        bytecode = Gvm.parse(file.read).value

        # create the prog list instance
        list = ProgList::EndOfFile.new(file)
        list.register(Prog.new) if list.empty?

        # take the uuid if any
        uuid = args.shift || 0

        # build the virtual machine
        vm = VM.new(uuid, bytecode, list)

        # Run it
        vm.run

        # Puts the current proglist
        puts vm.proglist.to_relation
      end

    end # class Command
  end # class VM
end # module Gisele