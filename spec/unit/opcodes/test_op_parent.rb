require 'spec_helper'
module Gisele
  class VM
    describe "op_parent" do

      let(:list){ ProgList.memory         }
      let(:vm)  { VM.new @child, [], list }

      context 'with a parent' do

        before do
          @parent = list.save Prog.new
          @child = list.save Prog.new(:parent => @parent)
        end

        it 'puts the parent of the current prog on the stack' do
          vm.stack = [ ]
          vm.op_parent
          vm.stack.should eq([ vm.proglist.fetch(@parent) ])
        end

      end

      context 'without parent' do

        before do
          @child = list.save Prog.new
        end

        it 'puts the parent of the current prog on the stack' do
          vm.stack = [ ]
          vm.op_parent
          vm.stack.should eq([ nil ])
        end

      end

    end
  end
end