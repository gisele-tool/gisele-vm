require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_event" do

      let(:kern){ kernel(Prog.new(:puid => 17)) }

      before do
        kern.stack = [ ["world"] ]
      end

      it 'calls the event interface' do
        kern.op_event(:hello)
        events.include?(an_event).should be_true
      end

      it 'can take the event kind from the stack' do
        kern.op_push :hello
        kern.op_event
        events.include?(an_event).should be_true
      end

    end
  end
end
