require 'spec_helper'
module Gisele
  class VM
    describe "op_notify" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.save Prog.new(:wait => [12])
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0, 12 ]
      end

      it 'enlists the puid in prog wait list' do
        vm.proglist.fetch(0).wait.should eq([12])
        vm.op_notify
        @at0.wait.should eq([])
        vm.proglist.fetch(0).wait.should eq([12])
        vm.stack.should eq([ @at0 ])
      end

    end
  end
end
