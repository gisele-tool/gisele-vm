require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_push" do

      before do
        kernel.stack = [ 1 ]
      end

      it 'fetches with the puid' do
        kernel.op_push 'hello'
        kernel.stack.should eq([ 1, 'hello' ])
      end

    end
  end
end
