require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_pop" do

      before do
        runner.stack = [ 1, 2 ]
      end

      it 'fetches with the puid' do
        runner.op_pop
        runner.stack.should eq([ 1 ])
      end

      it 'allows specifying the number of pops to do' do
        runner.op_pop(2)
        runner.stack.should eq([ ])
      end

    end
  end
end
