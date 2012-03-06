require 'spec_helper'
module Gisele
  module Compiling
    describe Gts2Bytecode, "on_event" do

      let(:gts) do
        VM::Gts.new do
          add_state :kind => :event
          add_state :kind => :nop
          connect(0, 1, :symbol => :hello, :event_args => [ "world" ])
        end
      end
      let(:compiler){ Gts2Bytecode.new }
      let(:bytecode){ compiler.builder.to_a }

      before do
        subject
      end

      subject do
        compiler.on_event(gts.ith_state(0))
      end

      it 'should generate the expected bytecode' do
        bytecode.should eq([:gvm,
          [:block, :s0,
            [:then, :s1],
            [:then, :e0]],
          [:block, :e0,
            [:push, [ "world"] ],
            [:event, :hello] ]
        ])
      end

    end
  end
end
