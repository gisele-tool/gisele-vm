require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_event" do

      let(:kern){ kernel(17)                       }
      let(:evt) { Event.new(17, :hello, ["World"]) }

      before do
        kern.stack = [ ["World"] ]
      end

      it 'calls the event interface' do
        kern.op_event(:hello)
        events.include?(evt).should be_true
      end

      it 'can take the event kind from the stack' do
        kern.op_push :hello
        kern.op_event
        events.include?(evt).should be_true
      end

    end
  end
end
