require 'spec_helper'
module Gisele
  module Compiling
    describe Gts2Bytecode, "on_fork" do

      let(:gts) do
        VM::Gts.new do
          add_state :kind => :fork
          add_state :kind => :join
          add_state :kind => :event
          add_state :kind => :event
          connect(0, 1, :symbol => :"(wait)")
          connect(0, 2, :symbol => :"(forked#1)")
          connect(0, 3, :symbol => :"(forked#2)")
          connect(2, 1, :symbol => :ping)
          connect(3, 1, :symbol => :pong)
        end
      end
      let(:compiler){ Gts2Bytecode.new      }
      let(:bytecode){ compiler.builder.to_a }

      before do
        subject
      end

      subject do
        compiler.on_fork(gts.ith_state(0))
      end

      it 'should generate the expected bytecode' do
        bytecode.should eq([:gvm,
          [:block, :s0,
            [:push, :s1],
            [:push, [:s2, :s3]],
            [:then, :fork]]
        ])
      end

    end
  end
end
