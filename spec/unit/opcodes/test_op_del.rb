require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_del" do

      before do
        kernel.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World", :other => true} }

        it 'removes the key from the hash' do
          kernel.op_del(:hello)
          kernel.stack.should eq([ {:other => true} ])
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :hello
          kernel.op_del
          kernel.stack.should eq([ {:other => true} ])
        end
      end

      context 'with an array' do
        let(:receiver){ [:hello, :world] }

        it 'pushes the result on the stack' do
          kernel.op_del(:hello)
          kernel.stack.should eq([[:world]])
        end

        it 'takes the attribute name from the stack if unspecified' do
          kernel.op_push :hello
          kernel.op_del
          kernel.stack.should eq([[:world]])
        end
      end

    end
  end
end
