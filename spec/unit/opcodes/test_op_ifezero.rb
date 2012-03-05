require 'spec_helper'
module Gisele
  class VM
    describe "op_ifezero" do

      let(:vm){ VM.new(nil, []) }

      subject{
        vm.opcodes = [ [:ifezero], [:push, 12], [:push, 24] ]
        vm.run(nil, stack)
        vm.stack
      }

      context 'when zero is on the stack' do
        let(:stack){ [ 0 ] }

        it 'skips the second op' do
          subject.should eq([ 0, 12 ])
        end

      end

      context 'when peek is not zero' do
        let(:stack){ [ 56 ] }

        it 'skips the first op' do
          subject.should eq([ 56, 24 ])
        end

      end

    end
  end
end
