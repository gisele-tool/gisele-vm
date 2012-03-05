require 'spec_helper'
module Gisele
  class VM
    describe "op_puid" do

      let(:vm){ VM.new :test_self, [] }

      it 'pushes the puid on top of the stack' do
        vm.stack = [:hello]
        vm.op_puid
        vm.stack.should eq([:hello, :test_self])
      end

    end
  end
end
