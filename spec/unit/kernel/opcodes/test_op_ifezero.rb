require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_ifezero" do

      subject do
        runner.opcodes = [ [:ifezero], [:push, 12], [:push, 24] ]
        runner.run(nil, stack)
        runner.stack
      end

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
