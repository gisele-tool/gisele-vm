require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_parent" do

      let(:kern){ kernel(@child) }

      context 'with a parent' do

        before do
          @parent = list.save Prog.new
          @child  = list.save Prog.new(:parent => @parent)
        end

        it 'puts the parent of the current prog on the stack' do
          kern.stack = [ ]
          kern.op_parent
          kern.stack.should eq([ list.fetch(@parent) ])
        end

      end

      context 'without parent' do

        before do
          @child = list.save Prog.new
        end

        it 'puts the parent of the current prog on the stack' do
          kern.stack = [ ]
          kern.op_parent
          kern.stack.should eq([ nil ])
        end

      end

    end
  end
end
