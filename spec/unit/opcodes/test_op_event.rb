require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_event" do

      let(:vm){ Kernel.new self, [], 17 }

      def event(kind, args)
        @called = [kind, args]
      end

      before do
        vm.stack = [ ["World"] ]
      end

      it 'calls the event interface' do
        vm.op_event(:hello)
        @called.should eq([:hello, [17, "World"]])
      end

      it 'can take the event kind from the stack' do
        vm.op_push :hello
        vm.op_event
        @called.should eq([:hello, [17, "World"]])
      end

    end
  end
end
