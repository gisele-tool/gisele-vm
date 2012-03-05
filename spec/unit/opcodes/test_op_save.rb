require 'spec_helper'
module Gisele
  class VM
    describe "op_save" do

      let(:vm){ VM.new 0, [] }

      before do
        @puid0 = vm.proglist.save Prog.new
        @puid1 = vm.proglist.save Prog.new
        @at0 = vm.proglist.fetch(@puid0)
        @at1 = vm.proglist.fetch(@puid1)
        vm.stack = [ @at0, @at1 ]
      end

      it 'saves the prog on the top of the stack' do
        vm.peek.pc = 12
        vm.proglist.fetch(@puid1).pc.should eq(0)
        vm.op_save
        vm.proglist.fetch(@puid1).pc.should eq(12)
        vm.stack.should eq([ @at0, @at1.puid ])
      end

      it 'allows specifying the number of progs to save' do
        vm.stack.each_with_index{|prog,i| prog.pc = 12 + i}
        vm.op_save 2
        vm.proglist.fetch(@puid0).pc.should eq(12)
        vm.proglist.fetch(@puid1).pc.should eq(13)
        vm.stack.should eq([ @at0.puid, @at1.puid ])
      end

    end
  end
end
