require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_save" do

      before do
        @puid0 = list.save Prog.new
        @puid1 = list.save Prog.new
        @at0 = list.fetch(@puid0)
        @at1 = list.fetch(@puid1)
        runner.stack = [ @at0, @at1 ]
      end

      it 'saves the prog on the top of the stack' do
        runner.peek.pc = 12
        list.fetch(@puid1).pc.should eq(0)
        runner.op_save
        list.fetch(@puid1).pc.should eq(12)
        runner.stack.should eq([ @at0, @at1.puid ])
      end

      it 'allows specifying the number of progs to save' do
        runner.stack.each_with_index{|prog,i| prog.pc = 12 + i}
        runner.op_save 2
        list.fetch(@puid0).pc.should eq(12)
        list.fetch(@puid1).pc.should eq(13)
        runner.stack.should eq([ @at0.puid, @at1.puid ])
      end

    end
  end
end
