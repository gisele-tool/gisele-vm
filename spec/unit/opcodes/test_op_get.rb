require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_get" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.stack = [ receiver ]
      end

      after do
        vm.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack' do
          vm.op_get(:hello)
          vm.stack.last.should eq("World")
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :hello
          vm.op_get
          vm.stack.last.should eq("World")
        end

        it 'supports getting nil' do
          vm.op_get(:nosuchone)
          vm.stack.last.should be_nil
        end

        it 'does not try to call methods' do
          vm.op_get(:fetch)
          vm.stack.last.should be_nil
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack' do
          vm.op_get(:pc)
          vm.stack.last.should eq(12)
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :pc
          vm.op_get
          vm.stack.last.should eq(12)
        end

        it 'raises an Error if no such method' do
          lambda{
            vm.op_get(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
