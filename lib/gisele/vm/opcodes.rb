module Gisele
  class VM
    module Opcodes

    private

                                                              ### CURRENT PROGRAM HANDLING

      # Puts the current uuid on top of the stack
      def op_self
        push @uuid
      end

                                                                ### GETTING PROGS ON STACK

      # Pops an uuid. Fetches and pushes the corresponding program.
      def op_fetch
        push @proglist.fetch(pop)
      end

      # Pops an uuid. Creates a child program of it. Registers that child and
      # pushes its uuid back on the stack.
      def op_new
        push @proglist.register(Prog.new(:parent => pop))
      end

                                                                 ### CODE STACK MANAGEMENT

      # Pops a label. Pushes opcodes at that location on the code stack.
      def op_pushc
        @opcodes += @bytecode[pop]
      end

                                                                 ### DATA STACK MANAGEMENT

       # Pushes `arg` on the data stack.
       def op_push(arg)
         push arg
       end

       # Pops the top element from the stack.
       def op_pop
         pop
       end

                                                                  ### TOP PROGRAM HANDLING

      # Pushes the parent uuid of the top program.
      def op_parent
        push peek.parent
      end

      # Pushes the program counter of the top program.
      def op_pc
        push peek.pc
      end

      # Pops a label. Sets the program counter of the top program to it.
      def op_setpc
        label = pop
        peek.pc = label
      end

      # Set the `start` attribute to true on the top program
      def op_start
        peek.start = true
      end

      # Pops the top program from the stack. Saves it. Pushes its uuid back on
      # the stack.
      def op_save
        push @proglist.save pop
      end

      # Pops an uuid. Adds it to the notifying list of the peek program.
      def op_wait
        uuid = pop
        peek.wait << uuid
      end

      # Pops a uuid. Removes it from the wait list of the peek program.
      def op_notify
        uuid = pop
        peek.wait.delete uuid
      end

      # Pops a label. If the wait list of the peek program is empty then pushes
      # the opcodes at that location on the code stack. Otherwise do nothing.
      def op_resume
        label = pop
        @opcodes += @bytecode[label] if peek.wait.empty?
      end

    end # module Opcodes
  end # class VM
end # module Gisele