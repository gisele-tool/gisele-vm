require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_unfold" do

      it 'unfolds the op array' do
        kernel.stack = [ :a, [:b, :c] ]
        kernel.op_unfold
        kernel.stack.should eq([:a, :b, :c])
      end

      it 'is the reverse of fold' do
        kernel.stack = [:a, [:b, :c] ]
        kernel.op_unfold
        kernel.stack.should eq([:a, :b, :c])
        kernel.op_fold(2)
        kernel.stack.should eq([:a, [:b, :c]])
      end

    end
  end
end
