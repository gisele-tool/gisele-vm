require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_unfold" do

      it 'unfolds the op array' do
        runner.stack = [ :a, [:b, :c] ]
        runner.op_unfold
        runner.stack.should eq([:a, :b, :c])
      end

      it 'is the reverse of fold' do
        runner.stack = [:a, [:b, :c] ]
        runner.op_unfold
        runner.stack.should eq([:a, :b, :c])
        runner.op_fold(2)
        runner.stack.should eq([:a, [:b, :c]])
      end

    end
  end
end
