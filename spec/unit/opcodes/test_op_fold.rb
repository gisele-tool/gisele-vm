require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fold" do

      before do
        kernel.stack = [ :a, :b, :c ]
      end

      it 'pushes an array with the specified number of elements' do
        kernel.op_fold(2)
        kernel.stack.should eq([:a, [:b, :c]])
      end

      it 'supports traking n from the stack' do
        kernel.op_push 2
        kernel.op_fold
        kernel.stack.should eq([:a, [:b, :c]])
      end

      it 'supports 0' do
        kernel.op_push 0
        kernel.op_fold
        kernel.stack.should eq([:a, :b, :c, []])
      end

    end
  end
end
