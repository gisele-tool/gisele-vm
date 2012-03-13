require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_set" do

      after do
        runner.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {} }

        before do
          runner.stack = [ receiver, "World" ]
        end

        after do
          runner.stack.last[:hello].should eq("World")
        end

        it 'sets the attribute under the specified key' do
          runner.op_set(:hello)
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :hello
          runner.op_set
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new }

        before do
          runner.stack = [ receiver, 12 ]
        end

        after do
          runner.stack.last.pc.should eq(12)
        end

        it 'sets the value under the attribute' do
          runner.op_set(:pc)
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :pc
          runner.op_set
        end

        it 'raises an Error if no such method' do
          lambda{
            runner.op_set(:nosuchone)
          }.should raise_error(VM::Error)
          runner.stack.first.pc = 12                ## for after block
        end
      end

    end
  end
end
