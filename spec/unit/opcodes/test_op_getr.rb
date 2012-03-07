require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_getr" do

      before do
        kernel.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack and removes the receiver' do
          kernel.op_getr(:hello)
          kernel.stack.should eq(["World"])
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :hello
          kernel.op_getr
          kernel.stack.should eq(["World"])
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack and removes the receiver' do
          kernel.op_getr(:pc)
          kernel.stack.should eq([12])
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :pc
          kernel.op_getr
          kernel.stack.should eq([12])
        end

        it 'raises an Error if no such method' do
          lambda{
            kernel.op_getr(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
