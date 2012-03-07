require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_event" do

      let(:vm){ Kernel.new self, [], 17 }

      def event(event)
        @event = event
      end

      before do
        vm.stack = [ ["World"] ]
      end

      it 'calls the event interface' do
        vm.op_event(:hello)
        @event.should eq(Event.new(17, :hello, ["World"]))
      end

      it 'can take the event kind from the stack' do
        vm.op_push :hello
        vm.op_event
        @event.should eq(Event.new(17, :hello, ["World"]))
      end

    end
  end
end
