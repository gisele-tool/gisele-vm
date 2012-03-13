require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_event" do

      let(:runn){ runner(Prog.new(:puid => 17)) }

      before do
        runn.stack = [ ["world"] ]
      end

      it 'calls the event interface' do
        runn.op_event(:hello)
        events.include?(an_event).should be_true
      end

      it 'can take the event kind from the stack' do
        runn.op_push :hello
        runn.op_event
        events.include?(an_event).should be_true
      end

    end
  end
end
