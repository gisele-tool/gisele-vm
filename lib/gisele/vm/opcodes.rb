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
      def op_get(attrname = nil, remove=false)
        attrname ||= pop
        receiver = remove ? pop : peek
        if receiver.respond_to?(:[])
          push receiver[attrname]
        elsif receiver.respond_to?(attrname)
          push receiver.send(attrname)
        else
          raise Error, "Unable to get #{attrname} on #{receiver.inspect}"
        end
      end

      # Same as +get+ but removes the original receiver from the stack.
      def op_getr(attrname = nil)
        op_get(attrname, true)
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
          raise Error, "Unable to set #{attrname} on #{receiver.inspect}"
        end
      end

      # If `attrname` is unspecified, pops it from the stack first. Expects an object
      # responding to :delete on top of the stack. Pops it, call `delete(attrname)` on
      # a duplicate and push the later back on the stack.
      def op_del(attrname = nil)
        attrname ||= pop
        push pop.dup
        peek.delete(attrname)
      end

      ### CONTROL ########################################################################

      # Does nothing at all
      def op_nop
      end

      # Pushes opcodes at label `at` on the code queue. If `at` is unspecified, it it
      # poped from the stack first
      def op_then(at = nil)
        enlist_bytecode_at(at || pop)
      end

      # If the peek object is equal to `val`, flip top operations and skip the first one.
      # Otherwise skip the top operation.
      def op_ifeeq(val = nil)
        if peek == val
          t = opcodes.shift
          opcodes.shift
          opcodes.unshift t
        else
          opcodes.shift
        end
      end

      # If the peek object is nil, flip top operations and skip the first one. Otherwise
      # skip the top operation.
      def op_ifenil
        op_ifeeq(nil)
      end

      # If the peek object is zero, flip top operations and skip the first one. Otherwise
      # skip the top operation.
      def op_ifezero
        op_ifeeq(0)
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
        cur = current_prog
        push(cur.parent==cur.puid ? nil : fetch(current_prog.parent))
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

      # Expects an array of labels on the stack. Same as +fork+ but in array version.
      # A resulting array of unsaved Prog is put back on the stack.
      def op_forka(at = nil)
        at ||= pop
        push at.map{|l| fork(l)}
      end

      # Pops `n` programs from the stack and save them. Pushes their puid back on
      # the stack after saving, in the original order. `n` is considered 1 if unspecified.
      def op_save(n = nil)
        progs = pop(n || 1)
        puids = save(progs)
        puids.reverse.each{|puid| push(puid)}
      end

      # Expects an array of Progs on the stack. Similar to +save+ but in array version.
      # Push the resulting puids back on the stack in an array.
      def op_savea
        push save(pop)
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
