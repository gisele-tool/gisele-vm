require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_save" do

      before do
        @puid0 = list.save Prog.new
        @puid1 = list.save Prog.new
        @at0 = list.fetch(@puid0)
        @at1 = list.fetch(@puid1)
        kernel.stack = [ @at0, @at1 ]
      end

      it 'saves the prog on the top of the stack' do
        kernel.peek.pc = 12
        list.fetch(@puid1).pc.should eq(0)
        kernel.op_save
        list.fetch(@puid1).pc.should eq(12)
        kernel.stack.should eq([ @at0, @at1.puid ])
      end

      it 'allows specifying the number of progs to save' do
        kernel.stack.each_with_index{|prog,i| prog.pc = 12 + i}
        kernel.op_save 2
        list.fetch(@puid0).pc.should eq(12)
        list.fetch(@puid1).pc.should eq(13)
        kernel.stack.should eq([ @at0.puid, @at1.puid ])
      end

    end
  end
end
