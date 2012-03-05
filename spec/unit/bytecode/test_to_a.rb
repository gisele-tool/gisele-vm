require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, 'to_a' do

      let(:gvm){
        [:gvm, [:block, :s0, [:push, 12]]]
      }
      let(:bytecode){
        Bytecode.new(gvm)
      }

      it 'returns the gvm array' do
        bytecode.to_a.should eq(gvm)
      end

    end
  end
end
