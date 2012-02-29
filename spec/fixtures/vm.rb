module Gisele
  class VM
    attr_reader :puid
    attr_accessor :opcodes
    attr_accessor :stack
    attr_accessor :proglist

    public :push, :peek, :pop

    public :op_pushc,
           :op_puid,
           :op_parent,
           :op_pc,
           :op_fetch,
           :op_setpc,
           :op_schedule,
           :op_unschedule,
           :op_save,
           :op_wait,
           :op_notify,
           :op_pop,
           :op_push,
           :op_send,
           :op_invoke,
           :op_group,
           :op_resume,
           :op_event,
           :op_fork,
           :op_cont

  end
end
