require 'spec_helper'
module Gisele
  class VM
    describe "op_del" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.stack = [ receiver ]
      end

      context 'with a hash' do
        let(:receiver){ {:hello => "World", :other => true} }

        it 'removes the key from the hash' do
          vm.op_del(:hello)
          vm.stack.should eq([ {:other => true} ])
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :hello
          vm.op_del
          vm.stack.should eq([ {:other => true} ])
        end
      end

      context 'with an array' do
        let(:receiver){ [:hello, :world] }

        it 'pushes the result on the stack' do
          vm.op_del(:hello)
          vm.stack.should eq([[:world]])
        end

        it 'takes the attribute name from the stack if unspecified' do
          vm.op_push :hello
          vm.op_del
          vm.stack.should eq([[:world]])
        end
      end

    end
  end
end
