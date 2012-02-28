require 'spec_helper'
module Gisele
  class VM
    describe "op_setpc" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.register Prog.new
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0, 1 ]
      end

      it 'sets the program counter' do
        vm.op_setpc
        @at0.pc.should eq(1)
      end

      it 'does not touch the original' do
        vm.op_setpc
        vm.proglist.fetch(0).pc.should eq(0)
      end

    end
  end
end
