require 'spec_helper'
module Gisele
  class VM
    describe "op_push" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.stack = [ 1 ]
      end

      it 'fetches with the uuid' do
        vm.op_push 'hello'
        vm.stack.should eq([ 1, 'hello' ])
      end

    end
  end
end