require 'spec_helper'
module Gisele
  class VM
    describe "op_send" do

      let(:vm){ VM.new 0, [] }

      it 'pushes the result on the stack' do
        vm.stack = [ 1, :+, [ 2 ] ]
        vm.op_send
        vm.stack.should eq([ 3 ])
      end

    end
  end
end