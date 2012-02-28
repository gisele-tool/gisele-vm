module Gisele
  class VM
    attr_reader :uuid
    attr_accessor :opcodes
    attr_accessor :stack
    attr_accessor :proglist

    public :push, :peek, :pop

    public :op_pushc,
           :op_self,
           :op_parent,
           :op_pc,
           :op_fetch,
           :op_setpc,
           :op_start,
           :op_stop,
           :op_save,
           :op_new,
           :op_wait,
           :op_notify,
           :op_pop,
           :op_push,
           :op_send,
           :op_invoke,
           :op_slice,
           :op_resume

  end
end