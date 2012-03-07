require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_send" do

      let(:vm){ Kernel.new }

      it 'pushes the result on the stack' do
        vm.stack = [ 1, [ 2 ] ]
        vm.op_send(:+)
        vm.stack.should eq([ 3 ])
      end

      it 'takes the method name from the stack when unspecified' do
        vm.stack = [ 1, [ 2 ], :+ ]
        vm.op_send
        vm.stack.should eq([ 3 ])
      end

    end
  end
end
