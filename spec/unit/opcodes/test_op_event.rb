require 'spec_helper'
module Gisele
  class VM
    describe "op_event" do

      let(:vm){ VM.new 17, [], ProgList.memory, self }

      def call(puid, kind, args)
        @called = [puid, kind, args]
      end

      before do
        vm.stack = [ ["World"] ]
      end

      it 'calls the event interface' do
        vm.op_event(:hello)
        @called.should eq([17, :hello, ["World"]])
      end

      it 'can take the event kind from the stack' do
        vm.op_push :hello
        vm.op_event
        @called.should eq([17, :hello, ["World"]])
      end

    end
  end
end
