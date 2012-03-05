require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler, ".compile" do

        let(:expected){
          Grammar.sexpr fixtures/'ts.gvm'
        }

        subject{
          bytecode = Bytecode.coerce(input)
          bytecode.should be_a(Bytecode)
          bytecode.to_a
        }

        context 'on a .gts file' do
          let(:input){ fixtures/'ts.gts' }
          it{ should eq(expected) }
        end

      end
    end
  end
end
