module Gisele
  class VM
    attr_reader :puid
    attr_accessor :opcodes
    attr_accessor :stack
    attr_accessor :proglist

    public :push, :peek, :pop

    public :op_then,
           :op_puid,
           :op_parent,
           :op_fetch,
           :op_schedule,
           :op_unschedule,
           :op_save,
           :op_wait,
           :op_notify,
           :op_pop,
           :op_push,
           :op_send,
           :op_invoke,
           :op_fold,
           :op_unfold,
           :op_event,
           :op_fork,
           :op_cont,
           :op_get,
           :op_set,
           :op_self,
           :op_end,
           :op_pick,
           :op_flip,
           :op_nop,
           :op_ifenil

  end
end
