require 'spec_helper'
module Gisele
  class VM
    describe "op_self" do

      let(:vm){ VM.new 0, [] }

      before do
        @puid0 = vm.proglist.save Prog.new
      end

      it 'puts the current prog on the stack' do
        vm.stack = [ ]
        vm.op_self
        vm.stack.should eq([ vm.proglist.fetch(@puid0) ])
      end

    end
  end
end
