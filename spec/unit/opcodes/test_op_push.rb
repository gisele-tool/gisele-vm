require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_push" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.stack = [ 1 ]
      end

      it 'fetches with the puid' do
        vm.op_push 'hello'
        vm.stack.should eq([ 1, 'hello' ])
      end

    end
  end
end
