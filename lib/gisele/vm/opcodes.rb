module Gisele
  class VM
    module Opcodes

    private

      ### GENERIC OPCODES ################################################################

      # Pops a method name on the stack unless `method` is specified. Pops an array of
      # argument `args`. Pops an object `receiver`. Invoke `method` on `receiver`, passing
      # arguments `args`. Push the result back on the stack.
      def op_send(method = nil, push_result = true)
        method ||= pop
        args     = pop
        receiver = pop
        result   = receiver.send(method, *args)
        push result if push_result
      end

      # Same as `op_send` but does not keep the result on the stack.
      def op_invoke(method = nil)
        op_send(method, false)
      end

      # Push the value of the attribute `attrname` of the top object. If `attrname` is not
      # specified, pops it from the stack first.
      def op_get(attrname = nil)
        attrname ||= pop
        receiver = peek
        if receiver.respond_to?(:[])
          push receiver[attrname]
        elsif receiver.respond_to?(attrname)
          push receiver.send(attrname)
        else
          raise Error, "Unable to get #{attrname} on #{receiver}"
        end
      end

      # If `attrname` is unspecified, pops it from the stack first. Pops a value `val`
      # from the stack. Set attribute `attrname` to `val` on the top object.
      def op_set(attrname = nil)
        attrname ||= pop
        attrvalue  = pop
        receiver   = peek
        if receiver.respond_to?(:[]=)
          receiver[attrname] = attrvalue
        elsif receiver.respond_to?(:"#{attrname}=")
          receiver.send(:"#{attrname}=", attrvalue)
        else
          raise Error, "Unable to set #{attrname} on #{receiver}"
        end
      end

      ### LIFECYCLE ######################################################################

      # Puts the puid of the executing Prog on the stack
      def op_puid
        push puid
      end

      # Fetches the Prog whose id is `puid` and pushes it on the stack. if `puid` is not
      # specified, pops it from the stack first.
      def op_fetch(puid = nil)
        push fetch(puid || pop)
      end

      # Fork the current Prog. Set its program counter to `at` (taken from the stack if
      # not specified), and mark it as schedulable by default. The resulting Prog is
      # pushed on the stack. It is not saved.
      def op_fork(at = nil)
        push fork(at || pop)
      end

      # Sets the program counter of the current Prog to `at` (taken from the stack if not
      # specified). Unschedule it. Push the unsaved Prog on the stack.
      def op_cont(at = nil)
        push current_prog(:pc => at || pop, :progress => false)
      end

      # Pushes opcodes at label `at` on the code queue. If `at` is unspecified, it it
      # poped from the stack first
      def op_then(at = nil)
        enlist_bytecode_at(at || pop)
      end

      # Set the `progress` attribute to true on the top program
      def op_schedule
        peek.progress = true
      end

      # Set the `progress` attribute to false on the top program
      def op_unschedule
        peek.progress = false
      end

      # Pops `n` programs from the stack and save them. Pushes their puid back on
      # the stack after saving, in the original order. `n` is considered 1 if unspecified.
      def op_save(n = nil)
        progs = pop(n || 1)
        puids = save(progs)
        puids.reverse.each{|puid| push(puid)}
      end

      ### DATA STACK MANAGEMENT ##########################################################

      # Pushes `arg` on the data stack.
      def op_push(arg)
        push arg
      end

      # Pops the top element from the stack.
      def op_pop(n = nil)
        pop(n)
      end

      # Pops `n` elements from the stack, keep them in a new array and push the later
      # back on the stack. If `n` is not provided, it is taken from the stack first.
      def op_group(nb = nil)
        n, arr = (nb || pop), []
        n.times{ arr << pop }
        push arr.reverse
      end

      ### EVENT HANDLING #################################################################

      # Pops event arguments from the stack (an array). Send an event of the specified
      # kind on the event interface. If `kind` is not provided, it is first poped from
      # the stack
      def op_event(kind = nil)
        kind ||= pop
        args = pop
        event(kind, args)
      end

      ### TOP PROGRAM HANDLING ###########################################################

      # Pushes the parent puid of the top program.
      def op_parent
        push peek.parent
      end

      # Pops an puid. Adds it to the notifying list of the peek program.
      def op_wait
        puid = pop
        peek.wait << puid
      end

      # Pops a puid. Removes it from the wait list of the peek program.
      def op_notify
        puid = pop
        peek.wait.delete puid
      end

      # Pops a label. If the wait list of the peek program is empty then pushes
      # the opcodes at that location on the code stack. Otherwise do nothing.
      def op_resume
        label = pop
        enlist_bytecode_at(label) if peek.wait.empty?
      end

    end # module Opcodes
  end # class VM
end # module Gisele
