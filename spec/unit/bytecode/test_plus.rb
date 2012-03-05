require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '+' do

      subject{
        left + right
      }

      let(:left) { Bytecode.coerce('s0: push 12') }
      let(:right){ 's1: push 14'                  }

      it 'returns a Bytecode' do
        subject.should be_a(Bytecode)
      end

      it 'denotes the concatenation of bytecodes' do
        expected = [:gvm,
          [:block, :s0, [ :push, 12 ]],
          [:block, :s1, [ :push, 14 ]]
        ]
        subject.to_a.should eq(expected)
      end

    end
  end
end
