require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_set" do

      let(:vm){ Kernel.new }

      after do
        vm.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {} }

        before do
          vm.stack = [ receiver, "World" ]
        end

        after do
          vm.stack.last[:hello].should eq("World")
        end

        it 'sets the attribute under the specified key' do
          vm.op_set(:hello)
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :hello
          vm.op_set
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new }

        before do
          vm.stack = [ receiver, 12 ]
        end

        after do
          vm.stack.last.pc.should eq(12)
        end

        it 'sets the value under the attribute' do
          vm.op_set(:pc)
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :pc
          vm.op_set
        end

        it 'raises an Error if no such method' do
          lambda{
            vm.op_set(:nosuchone)
          }.should raise_error(VM::Error)
          vm.stack.first.pc = 12                ## for after block
        end
      end

    end
  end
end
