require 'spec_helper'
module Gisele
  class VM
    describe "op_parent" do

      let(:vm){ VM.new 0, [] }

      before do
        uuid  = vm.proglist.register Prog.new(:parent => 0)
        @child = vm.proglist.fetch(uuid)
      end

      it 'pushes the parent uuid on the stack' do
        vm.stack = [ :hello, @child ]
        vm.op_parent
        vm.stack.should eq([:hello, @child, 0])
      end

    end
  end
end