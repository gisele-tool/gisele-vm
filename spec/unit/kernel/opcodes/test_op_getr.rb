require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_getr" do

      before do
        runner.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World"} }

        it 'pushes the result on the stack and removes the receiver' do
          runner.op_getr(:hello)
          runner.stack.should eq(["World"])
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :hello
          runner.op_getr
          runner.stack.should eq(["World"])
        end
      end

      context 'with an object' do
        let(:receiver){ Prog.new(:pc => 12) }

        it 'pushes the result on the stack and removes the receiver' do
          runner.op_getr(:pc)
          runner.stack.should eq([12])
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :pc
          runner.op_getr
          runner.stack.should eq([12])
        end

        it 'raises an Error if no such method' do
          lambda{
            runner.op_getr(:nosuchone)
          }.should raise_error(VM::Error)
        end
      end

    end
  end
end
