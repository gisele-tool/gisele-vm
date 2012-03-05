require 'spec_helper'
module Gisele
  class VM
    describe "op_unfold" do

      let(:vm){ VM.new 0, [] }

      it 'unfolds the op array' do
        vm.stack = [ :a, [:b, :c] ]
        vm.op_unfold
        vm.stack.should eq([:a, :b, :c])
      end

      it 'is the reverse of fold' do
        vm.stack = [:a, [:b, :c] ]
        vm.op_unfold
        vm.stack.should eq([:a, :b, :c])
        vm.op_fold(2)
        vm.stack.should eq([:a, [:b, :c]])
      end

    end
  end
end
