require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_self" do

      let(:list){ ProgList.memory            }
      let(:vm)  { Kernel.new list, [], @puid }

      before do
        @puid = list.save Prog.new
      end

      it 'puts the current prog on the stack' do
        vm.stack = [ ]
        vm.op_self
        vm.stack.should eq([ list.fetch(@puid) ])
      end

    end
  end
end
