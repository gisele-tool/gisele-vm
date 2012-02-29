require 'spec_helper'
module Gisele
  class VM
    describe "op_invoke" do

      let(:vm){ VM.new 0, [] }

      def hello(*args)
        @args = args
      end

      before do
        vm.stack = [ self, [ "world", "!" ] ]
      end

      after do
        @args.should eq(["world", "!"])
      end

      it 'invoke as expected' do
        vm.op_invoke(:hello)
      end

      it 'does not push back on the stack' do
        vm.op_invoke(:hello)
        vm.stack.should eq([])
      end

      it 'takes the method name from the stack if unspecified' do
        vm.op_push :hello
        vm.op_invoke
      end

    end
  end
end
