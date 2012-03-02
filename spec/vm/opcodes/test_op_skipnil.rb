require 'spec_helper'
module Gisele
  class VM
    describe "op_skipnil" do

      let(:vm){ VM.new 0, [] }

      context 'when the top value is nil' do

        it 'pops it and skips the next instruction' do
          vm.opcodes = [ [:skipnil], [:push, 12], [:push, 24] ]
          vm.run(nil, [ 1, nil ])
          vm.stack.should eq([ 1, 24 ])
        end

        it 'pops it and skips the specified number of instructions' do
          vm.opcodes = [ [:skipnil, 2], [:push, 12], [:push, 24] ]
          vm.run(nil, [ 1, nil ])
          vm.stack.should eq([ 1 ])
        end

      end # with nil

      context 'when the top value is not nil' do

        it 'does nothing' do
          vm.opcodes = [ [:skipnil], [:push, 12], [:push, 24] ]
          vm.run(nil, [ 1 ])
          vm.stack.should eq([ 1, 12, 24 ])
        end

      end # when not nil

    end
  end
end
