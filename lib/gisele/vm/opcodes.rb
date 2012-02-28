module Gisele
  class VM
    module Opcodes

    private

                                                              ### CURRENT PROGRAM HANDLING

      # Puts the uuid of the executing Prog on the stack
      def op_uuid
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

       # Pops an integer `n`. Pops `n` elements from the stack, keep them in a new array
       # and push the later on the stack.
       def op_slice
         n, arr = pop, []
         n.times{ arr << pop }
         push arr.reverse
       end

       # Pops an array of argument `args`. Pops a method name `m` (Symbol). Pops an object
       # `o`. Invoke `m` on `o`, passing arguments `args`. Push the result on the stack.
       def op_send
         args = pop
         m = pop
         o = pop
         push o.send(m, *args)
       end

       # Same as `op_send` but does not keep the result on the stack.
       def op_invoke
         op_send
         op_pop
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

      # Set the `start` attribute to false on the top program
      def op_stop
        peek.start = false
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