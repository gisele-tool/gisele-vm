require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_save" do

      let(:list){ ProgList.memory }
      let(:vm)  { Kernel.new list }

      before do
        @puid0 = list.save Prog.new
        @puid1 = list.save Prog.new
        @at0 = list.fetch(@puid0)
        @at1 = list.fetch(@puid1)
        vm.stack = [ [ @at0, @at1 ] ]
        vm.peek.each{|p| p.pc = 12}
      end

      subject do
        vm.op_savea
      end

      after do
        top = vm.peek
        top.each do |puid|
          list.fetch(puid).pc.should eq(12)
        end
      end

      it 'puts the saved puid back on the stack' do
        subject
        vm.stack.size.should eq(1)
        vm.peek.should be_a(Array)
      end

    end
  end
end
