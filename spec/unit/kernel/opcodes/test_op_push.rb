require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_push" do

      before do
        runner.stack = [ 1 ]
      end

      it 'fetches with the puid' do
        runner.op_push 'hello'
        runner.stack.should eq([ 1, 'hello' ])
      end

    end
  end
end
