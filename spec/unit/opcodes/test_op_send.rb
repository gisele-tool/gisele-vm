require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_send" do

      it 'pushes the result on the stack' do
        kernel.stack = [ 1, [ 2 ] ]
        kernel.op_send(:+)
        kernel.stack.should eq([ 3 ])
      end

      it 'takes the method name from the stack when unspecified' do
        kernel.stack = [ 1, [ 2 ], :+ ]
        kernel.op_send
        kernel.stack.should eq([ 3 ])
      end

    end
  end
end
