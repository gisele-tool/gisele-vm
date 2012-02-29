require 'spec_helper'
module Gisele
  class VM
    describe "op_parent" do

      let(:vm){ VM.new 0, [] }

      before do
        @puid0 = vm.proglist.save Prog.new
        @puid1 = vm.proglist.save Prog.new(:parent => @puid0)
      end

      it 'puts the parent of the current prog on the stack' do
        vm.stack = [ ]
        vm.op_parent
        vm.stack.should eq([ vm.proglist.fetch(@puid0) ])
      end

    end
  end
end
