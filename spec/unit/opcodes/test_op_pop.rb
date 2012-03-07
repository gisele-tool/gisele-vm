require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_pop" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.stack = [ 1, 2 ]
      end

      it 'fetches with the puid' do
        vm.op_pop
        vm.stack.should eq([ 1 ])
      end

      it 'allows specifying the number of pops to do' do
        vm.op_pop(2)
        vm.stack.should eq([ ])
      end

    end
  end
end
