require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_then" do

      let(:bc){
        Bytecode.coerce <<-BC.gsub(/^\s*/, '').strip
          hello: push 12
        BC
      }
      let(:kern){ VM.new(bc).kernel }

      before do
        kern.opcodes  = [ [:nop] ]
      end

      after do
        kern.opcodes.should eq([[:nop], [:push, 12]])
        kern.stack.should eq([:prev])
      end

      context 'without argument' do

        subject do
          kern.op_then
        end

        it 'pushes opcodes on the code stack' do
          kern.stack = [ :prev, :hello ]
          subject
        end

      end # without argument

      context 'without an argument' do

        subject do
          kern.op_then(:hello)
        end

        it 'pushes opcodes on the code stack' do
          kern.stack = [ :prev ]
          subject
        end

      end # with an argument

    end
  end
end
