require 'spec_helper'
module Gisele
  class VM
    class Kernel
      describe Runner, "stack" do

        it 'pushes at the end' do
          runner.stack = [:hello]
          runner.push :world
          runner.stack.should eq([:hello, :world])
        end

        it 'pops from the end' do
          runner.stack = [:hello, :world]
          runner.pop.should eq(:world)
          runner.stack.should eq([:hello])
        end

        it 'peeks at the the end' do
          runner.stack = [:hello, :world]
          runner.peek.should eq(:world)
          runner.stack.should eq([:hello, :world])
        end

      end
    end
  end
end
