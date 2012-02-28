require 'spec_helper'
module Gisele
  class VM
    describe "op_pushc" do

      let(:vm){ VM.new :test_pushc, [[:at_0], [:hello, :world]] }

      it 'pushes opcodes on the code stack' do
        vm.opcodes = [:begin]
        vm.stack = [ :prev, 1 ]
        vm.op_pushc
        vm.opcodes.should eq([:begin, :hello, :world])
        vm.stack.should eq([:prev])
      end

    end
  end
end
