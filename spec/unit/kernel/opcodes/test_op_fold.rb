require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fold" do

      before do
        runner.stack = [ :a, :b, :c ]
      end

      it 'pushes an array with the specified number of elements' do
        runner.op_fold(2)
        runner.stack.should eq([:a, [:b, :c]])
      end

      it 'supports traking n from the stack' do
        runner.op_push 2
        runner.op_fold
        runner.stack.should eq([:a, [:b, :c]])
      end

      it 'supports 0' do
        runner.op_push 0
        runner.op_fold
        runner.stack.should eq([:a, :b, :c, []])
      end

    end
  end
end
