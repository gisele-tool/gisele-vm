require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_flip" do

      let(:vm){ Kernel.new }

      before do
        vm.stack = [ 1, 2, 3 ]
      end

      it 'flips the two top elements' do
        vm.op_flip
        vm.stack.should eq([ 1, 3, 2 ])
      end

    end
  end
end
