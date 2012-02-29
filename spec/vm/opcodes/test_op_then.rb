require 'spec_helper'
module Gisele
  class VM
    describe "op_then" do

      let(:vm){ VM.new :test_then, [[:at_0], [:hello, :world]] }

      it 'pushes opcodes on the code stack' do
        vm.opcodes = [:begin]
        vm.stack = [ :prev, 1 ]
        vm.op_then
        vm.opcodes.should eq([:begin, :hello, :world])
        vm.stack.should eq([:prev])
      end

    end
  end
end
