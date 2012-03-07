require 'spec_helper'
module Gisele
  class VM
    describe Kernel, 'pop' do

      before do
        kernel.stack = [:a, :b, :c, :d]
      end

      it 'returns the poped object when n is not specified' do
        kernel.pop.should eq(:d)
        kernel.pop.should eq(:c)
        kernel.stack.should eq([:a, :b])
      end

      it 'returns the poped objects when n is specified' do
        kernel.pop(0).should eq([])
        kernel.pop(2).should eq([:d, :c])
        kernel.pop(1).should eq([:b])
      end

    end
  end
end
