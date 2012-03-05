require 'spec_helper'
module Gisele
  module Compiling
    describe Gts2Bytecode, ".compile" do

      let(:expected){
        VM::Bytecode::Grammar.sexpr fixtures/'ts.gvm'
      }

      subject{
        bytecode = VM::Bytecode.coerce(input)
        bytecode.should be_a(VM::Bytecode)
        bytecode.to_a
      }

      context 'on a .gts file' do
        let(:input){ fixtures/'ts.gts' }
        it{ should eq(expected) }
      end

    end
  end
end
