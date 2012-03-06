require 'spec_helper'
module Gisele
  module Compiling
    describe Gts2Bytecode, "on_listen" do

      let(:gts) do
        VM::Gts.new do
          add_state :kind => :listen
          add_state :kind => :nop
          add_state :kind => :nop
          connect(0, 1, :symbol => :ping)
          connect(0, 2, :symbol => :pong)
        end
      end
      let(:compiler){ Gts2Bytecode.new      }
      let(:bytecode){ compiler.builder.to_a }

      before do
        subject
      end

      subject do
        compiler.on_listen(gts.ith_state(0))
      end

      it 'should generate the expected bytecode' do
        bytecode.should eq([:gvm,
          [:block, :s0,
            [:push, {:ping=>:s1, :pong=>:s2}],
            [:then, :listen]]
        ])
      end

    end
  end
end
