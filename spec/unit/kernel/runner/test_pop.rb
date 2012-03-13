require 'spec_helper'
module Gisele
  class VM
    class Kernel
      describe Runner, 'pop' do

        before do
          runner.stack = [:a, :b, :c, :d]
        end

        it 'returns the poped object when n is not specified' do
          runner.pop.should eq(:d)
          runner.pop.should eq(:c)
          runner.stack.should eq([:a, :b])
        end

        it 'returns the poped objects when n is specified' do
          runner.pop(0).should eq([])
          runner.pop(2).should eq([:d, :c])
          runner.pop(1).should eq([:b])
        end

      end
    end
  end
end
