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
        bytecode = Gvm.bytecode(file)

        # create the prog list instance
        list = ProgList::EndOfFile.new(file)
        list.save(Prog.new) if list.empty?

        # take the puid if any
        puid = Integer(args.shift || 0)

        # build the virtual machine
        vm = VM.new(puid, bytecode, list)

        # Run it
        begin
          vm.run
        rescue Exception => ex
          puts "Error occured: #{ex.message}"
          puts ex.backtrace.join("\n")
          puts "--- Stack"
          puts vm.stack.join("\n")
          puts "--- Opcodes"
          puts vm.opcodes.join("\n")
          exit(1)
        end

        # Puts the current proglist
        puts vm.proglist.to_relation
      end

    end # class Command
  end # class VM
end # module Gisele
