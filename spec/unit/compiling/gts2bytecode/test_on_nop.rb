require 'spec_helper'
module Gisele
  module Compiling
    describe Gts2Bytecode, "on_nop" do

      let(:gts) do
        Gts.new do
          add_state :kind => :nop
          add_state :kind => :nop
          connect(0, 1, :symbol => nil)
        end
      end
      let(:compiler){ Gts2Bytecode.new      }
      let(:bytecode){ compiler.builder.to_a }

      before do
        subject
      end

      subject do
        compiler.on_nop(gts.ith_state(0))
      end

      it 'should generate the expected bytecode' do
        bytecode.should eq([:gvm, [:block, :s0, [:then, :s1]]])
      end

    end
  end
end
