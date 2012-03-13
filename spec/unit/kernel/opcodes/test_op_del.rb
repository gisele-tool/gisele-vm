require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_del" do

      before do
        runner.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World", :other => true} }

        it 'removes the key from the hash' do
          runner.op_del(:hello)
          runner.stack.should eq([ {:other => true} ])
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :hello
          runner.op_del
          runner.stack.should eq([ {:other => true} ])
        end
      end

      context 'with an array' do
        let(:receiver){ [:hello, :world] }

        it 'pushes the result on the stack' do
          runner.op_del(:hello)
          runner.stack.should eq([[:world]])
        end

        it 'takes the attribute name from the stack if unspecified' do
          runner.op_push :hello
          runner.op_del
          runner.stack.should eq([[:world]])
        end
      end

    end
  end
end
