require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fetch" do

      let(:list){ ProgList.memory }
      let(:vm)  { Kernel.new list }

      before do
        @parent = list.save Prog.new
        @child  = list.save Prog.new
        @at1 = list.fetch(@child)
      end

      after do
        vm.stack.should eq([ @at1 ])
      end

      it 'fetches the correct Prog with an arg' do
        vm.op_fetch(1)
      end

      it 'supports taking the puid from the stack' do
        vm.stack = [ 1 ]
        vm.op_fetch
      end

    end
  end
end
