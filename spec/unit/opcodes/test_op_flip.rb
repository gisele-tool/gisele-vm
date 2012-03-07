require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_flip" do

      before do
        kernel.stack = [ 1, 2, 3 ]
      end

      it 'flips the two top elements' do
        kernel.op_flip
        kernel.stack.should eq([ 1, 3, 2 ])
      end

    end
  end
end
