require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_invoke" do

      def hello(*args)
        @args = args
      end

      before do
        runner.stack = [ self, [ "world", "!" ] ]
      end

      after do
        @args.should eq(["world", "!"])
      end

      it 'invoke as expected' do
        runner.op_invoke(:hello)
      end

      it 'does not push back on the stack' do
        runner.op_invoke(:hello)
        runner.stack.should eq([])
      end

      it 'takes the method name from the stack if unspecified' do
        runner.op_push :hello
        runner.op_invoke
      end

    end
  end
end
