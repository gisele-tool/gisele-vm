require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "stack" do

      it 'pushes at the end' do
        kernel.stack = [:hello]
        kernel.push :world
        kernel.stack.should eq([:hello, :world])
      end

      it 'pops from the end' do
        kernel.stack = [:hello, :world]
        kernel.pop.should eq(:world)
        kernel.stack.should eq([:hello])
      end

      it 'peeks at the the end' do
        kernel.stack = [:hello, :world]
        kernel.peek.should eq(:world)
        kernel.stack.should eq([:hello, :world])
      end

    end
  end
end
