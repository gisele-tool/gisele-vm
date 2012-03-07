require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_ifenil" do

      let(:vm){ Kernel.new(nil, []) }

      subject{
        vm.opcodes = [ [:ifenil], [:push, 12], [:push, 24] ]
        vm.run(nil, stack)
        vm.stack
      }

      context 'when nil on the stack' do
        let(:stack){ [ nil ] }

        it 'skips the second op' do
          subject.should eq([ nil, 12 ])
        end

      end

      context 'when stack is empty' do
        let(:stack){ [ ] }

        it 'skips the second op' do
          subject.should eq([ 12 ])
        end

      end

      context 'when peek is not nil' do
        let(:stack){ [ 56 ] }

        it 'skips the first op' do
          subject.should eq([ 56, 24 ])
        end

      end

    end
  end
end
