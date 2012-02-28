require 'spec_helper'
module Gisele
  class VM
    describe "op_save" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.register Prog.new
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'saves the prog on the top of the stack' do
        vm.peek.pc = 12
        vm.proglist.fetch(0).pc.should eq(0)
        vm.op_save
        vm.proglist.fetch(0).pc.should eq(12)
        vm.stack.should eq([ @at0.uuid ])
      end

    end
  end
end