require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_set" do

      after do
        kernel.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {} }

        before do
          kernel.stack = [ receiver, "World" ]
        end

        after do
          kernel.stack.last[:hello].should eq("World")
        end

        it 'sets the attribute under the specified key' do
          kernel.op_set(:hello)
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :hello
          kernel.op_set
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new }

        before do
          kernel.stack = [ receiver, 12 ]
        end

        after do
          kernel.stack.last.pc.should eq(12)
        end

        it 'sets the value under the attribute' do
          kernel.op_set(:pc)
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :pc
          kernel.op_set
        end

        it 'raises an Error if no such method' do
          lambda{
            kernel.op_set(:nosuchone)
          }.should raise_error(VM::Error)
          kernel.stack.first.pc = 12                ## for after block
        end
      end

    end
  end
end
