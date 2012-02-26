require 'spec_helper'
module Gisele
  class VM
    describe "op_self" do

      let(:vm){ VM.new :test_self, [] }

      it 'pushes the uuid on top of the stack' do
        vm.stack = [:hello]
        vm.op_self
        vm.stack.should eq([:hello, :test_self])
      end

    end
  end
end