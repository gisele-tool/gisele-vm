require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_flip" do

      before do
        runner.stack = [ 1, 2, 3 ]
      end

      it 'flips the two top elements' do
        runner.op_flip
        runner.stack.should eq([ 1, 3, 2 ])
      end

    end
  end
end
