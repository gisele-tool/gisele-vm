require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_get" do

      before do
        runner.stack = [ receiver ]
      end

      after do
        runner.stack.first.should eq(receiver)
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack' do
          runner.op_get(:hello)
          runner.stack.last.should eq("World")
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :hello
          runner.op_get
          runner.stack.last.should eq("World")
        end

        it 'supports getting nil' do
          runner.op_get(:nosuchone)
          runner.stack.last.should be_nil
        end

        it 'does not try to call methods' do
          runner.op_get(:fetch)
          runner.stack.last.should be_nil
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack' do
          runner.op_get(:pc)
          runner.stack.last.should eq(12)
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :pc
          runner.op_get
          runner.stack.last.should eq(12)
        end

        it 'raises an Error if no such method' do
          lambda{
            runner.op_get(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
