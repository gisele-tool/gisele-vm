require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, 'fetch' do

      let(:bytecode){
        Bytecode.new([:gvm, [:block, :s0, [:push, 12]]])
      }

      it 'returns the set of instructions at that label' do
        bytecode[:s0].should eq([ [:push, 12] ])
      end

      it 'returns nil if no such label' do
        bytecode[:s10].should be_nil
      end

    end
  end
end
