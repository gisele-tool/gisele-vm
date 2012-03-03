require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler, ".compile" do

        let(:expected){
          Gvm.sexpr fixtures/'ts.gvm'
        }

        subject{
          bytecode = Bytecode.coerce(input)
          bytecode.should be_a(Bytecode)
          bytecode.to_a
        }

        context 'on a .adl file' do
          let(:input){ fixtures/'ts.adl' }
          it{ should eq(expected) }
        end

        context 'on a .gts file' do
          let(:input){ fixtures/'ts.gts' }
          it{ should eq(expected) }
        end

      end
    end
  end
end
