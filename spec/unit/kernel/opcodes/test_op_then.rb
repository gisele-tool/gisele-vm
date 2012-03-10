require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_then" do

      let(:bc){
        Bytecode.coerce <<-BC.gsub(/^\s*/, '').strip
          hello: push 12
        BC
      }
      let(:runn){ runner(bc) }

      before do
        runn.opcodes  = [ [:nop] ]
      end

      after do
        runn.opcodes.should eq([[:nop], [:push, 12]])
        runn.stack.should eq([:prev])
      end

      context 'without argument' do

        subject do
          runn.op_then
        end

        it 'pushes opcodes on the code stack' do
          runn.stack = [ :prev, :hello ]
          subject
        end

      end # without argument

      context 'without an argument' do

        subject do
          runn.op_then(:hello)
        end

        it 'pushes opcodes on the code stack' do
          runn.stack = [ :prev ]
          subject
        end

      end # with an argument

    end
  end
end
