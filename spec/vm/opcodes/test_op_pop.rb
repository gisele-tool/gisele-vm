require 'spec_helper'
module Gisele
  class VM
    describe "op_pop" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.stack = [ 1, 2]
      end

      it 'fetches with the uuid' do
        vm.op_pop
        vm.stack.should eq([ 1 ])
      end

    end
  end
end
