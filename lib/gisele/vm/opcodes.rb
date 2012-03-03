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

      # Push the current Prog on the stack.
      def op_self
        push current_prog
      end

      # Pushes the parent Prog of the executing program.
      def op_parent
        push fetch(current_prog.parent)
      end

      # Fetches the Prog whose id is `puid` and pushes it on the stack. if `puid` is not
      # specified, pops it from the stack first.
      def op_fetch(puid = nil)
        push fetch(puid || pop)
      end

      # Pick a scheduled Prog and puts it on the stack. This is a blocking opcode, i.e.
      # it will block the VM thread until a Prog can be found.
      def op_pick(&bl)
        push pick(&bl)
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

      # Sets the program counter of the current Prog to `-1`. Unschedule it. Push the
      # unsaved Prog on the stack.
      def op_end
        op_cont(-1)
      end

      # Set the `progress` attribute to true on the top program
      def op_schedule
        peek.progress = true
      end

      # Set the `progress` attribute to false on the top program
      def op_unschedule
        peek.progress = false
      end

      # Pops `n` (defaults to 1) puids from the stack. Add them to the wait list of the
      # current Prog. Put the later on the stack, unsaved.
      def op_wait(n = nil)
        prog = current_prog(:wait => pop(n || 1))
        prog.progress = prog.wait.empty?
        push prog
      end

      # Find the parent Prog. Remove the current puid from its wait list. Push it unsaved
      # on the stack.
      def op_notify
        parent = fetch(current_prog.parent)
        parent.wait.delete puid
        parent.progress = true if parent.wait.empty?
        push parent
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

      # Flips the two elements on top of the stack
      def op_flip
        pop(2).each{|e| push(e)}
      end

      # Pops `n` elements from the stack, keep them in a new array and push the later
      # back on the stack. If `n` is not provided, it is taken from the stack first.
      def op_fold(nb = nil)
        n, arr = (nb || pop), []
        n.times{ arr << pop }
        push arr.reverse
      end

      # Pops an array. Unfolds it on the stack.
      def op_unfold
        pop.each do |elm|
          push elm
        end
      end

      ### CODE MANAGEMENT ###############################################################

      # If the top element is nil, pops it and skips `n` instructions (defaults
      # to 1). Otherwise do nothing.
      def op_skipnil(n = nil)
        n ||= 1
        if peek.nil?
          pop
          n.times do
            opcodes.shift
          end
        end
      end

      # Pushes opcodes at label `at` on the code queue. If `at` is unspecified, it it
      # poped from the stack first
      def op_then(at = nil)
        enlist_bytecode_at(at || pop)
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

    end # module Opcodes
  end # class VM
end # module Gisele
