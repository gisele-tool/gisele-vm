require 'spec_helper'
module Gisele
  class VM
    describe "op_new" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.register Prog.new
        vm.stack = [ 0 ]
      end

      it 'sets the resulting uuid on the stack' do
        vm.op_new
        vm.stack.should eq([ 1 ])
        vm.proglist.fetch(1).parent.should eq(0)
      end

    end
  end
end