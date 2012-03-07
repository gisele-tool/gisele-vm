require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_get" do

      before do
        kernel.stack = [ receiver ]
      end

      after do
        kernel.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack' do
          kernel.op_get(:hello)
          kernel.stack.last.should eq("World")
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :hello
          kernel.op_get
          kernel.stack.last.should eq("World")
        end

        it 'supports getting nil' do
          kernel.op_get(:nosuchone)
          kernel.stack.last.should be_nil
        end

        it 'does not try to call methods' do
          kernel.op_get(:fetch)
          kernel.stack.last.should be_nil
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack' do
          kernel.op_get(:pc)
          kernel.stack.last.should eq(12)
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :pc
          kernel.op_get
          kernel.stack.last.should eq(12)
        end

        it 'raises an Error if no such method' do
          lambda{
            kernel.op_get(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
