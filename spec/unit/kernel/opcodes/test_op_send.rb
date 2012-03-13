require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_send" do

      it 'pushes the result on the stack' do
        runner.stack = [ 1, [ 2 ] ]
        runner.op_send(:+)
        runner.stack.should eq([ 3 ])
      end

      it 'takes the method name from the stack when unspecified' do
        runner.stack = [ 1, [ 2 ], :+ ]
        runner.op_send
        runner.stack.should eq([ 3 ])
      end

    end
  end
end
