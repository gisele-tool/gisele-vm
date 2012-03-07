require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_getr" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack and removes the receiver' do
          vm.op_getr(:hello)
          vm.stack.should eq(["World"])
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :hello
          vm.op_getr
          vm.stack.should eq(["World"])
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack and removes the receiver' do
          vm.op_getr(:pc)
          vm.stack.should eq([12])
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :pc
          vm.op_getr
          vm.stack.should eq([12])
        end

        it 'raises an Error if no such method' do
          lambda{
            vm.op_getr(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
