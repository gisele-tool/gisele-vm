require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_puid" do

      let(:vm){ Kernel.new :test_self }

      it 'pushes the puid on top of the stack' do
        vm.stack = [:hello]
        vm.op_puid
        vm.stack.should eq([:hello, :test_self])
      end

    end
  end
end
