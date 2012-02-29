require 'spec_helper'
module Gisele
  class VM
    describe "op_pc" do

      let(:vm){ VM.new 0, [] }

      before do
        puid = vm.proglist.register Prog.new(:pc => 17)
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'pushes the parent puid on the stack' do
        vm.op_pc
        vm.stack.should eq([@at0, 17])
      end

    end
  end
end
