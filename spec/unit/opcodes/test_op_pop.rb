require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_pop" do

      before do
        kernel.stack = [ 1, 2 ]
      end

      it 'fetches with the puid' do
        kernel.op_pop
        kernel.stack.should eq([ 1 ])
      end

      it 'allows specifying the number of pops to do' do
        kernel.op_pop(2)
        kernel.stack.should eq([ ])
      end

    end
  end
end
