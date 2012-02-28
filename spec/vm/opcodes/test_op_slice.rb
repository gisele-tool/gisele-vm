require 'spec_helper'
module Gisele
  class VM
    describe "op_push" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.stack = [ :a, :b, :c ]
      end

      it 'supports 0' do
        vm.op_push 0
        vm.op_slice
        vm.stack.should eq([:a, :b, :c, []])
      end

      it 'pushes an array with the specified number of elements' do
        vm.op_push 2
        vm.op_slice
        vm.stack.should eq([:a, [:b, :c]])
      end

    end
  end
end
