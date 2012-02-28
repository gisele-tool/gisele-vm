require 'spec_helper'
module Gisele
  class VM
    describe "the operand stack" do

      let(:vm){ VM.new :test_stack, [] }

      it 'pushes at the end' do
        vm.stack = [:hello]
        vm.push :world
        vm.stack.should eq([:hello, :world])
      end

      it 'pops from the end' do
        vm.stack = [:hello, :world]
        vm.pop.should eq(:world)
        vm.stack.should eq([:hello])
      end

      it 'peeks at the the end' do
        vm.stack = [:hello, :world]
        vm.peek.should eq(:world)
        vm.stack.should eq([:hello, :world])
      end

    end
  end
end
