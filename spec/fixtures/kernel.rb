module Gisele
  class VM
    class Kernel
      attr_reader :puid
      attr_accessor :opcodes
      attr_accessor :stack
      attr_accessor :proglist

      public :push, :peek, :pop

      public :op_then,
             :op_puid,
             :op_parent,
             :op_fetch,
             :op_save,
             :op_savea,
             :op_pop,
             :op_push,
             :op_send,
             :op_invoke,
             :op_fold,
             :op_unfold,
             :op_event,
             :op_fork,
             :op_forka,
             :op_get,
             :op_getr,
             :op_set,
             :op_del,
             :op_self,
             :op_flip,
             :op_nop,
             :op_ifenil,
             :op_ifezero
    end
  end
end
