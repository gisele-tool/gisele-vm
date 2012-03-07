require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_invoke" do

      def hello(*args)
        @args = args
      end

      before do
        kernel.stack = [ self, [ "world", "!" ] ]
      end

      after do
        @args.should eq(["world", "!"])
      end

      it 'invoke as expected' do
        kernel.op_invoke(:hello)
      end

      it 'does not push back on the stack' do
        kernel.op_invoke(:hello)
        kernel.stack.should eq([])
      end

      it 'takes the method name from the stack if unspecified' do
        kernel.op_push :hello
        kernel.op_invoke
      end

    end
  end
end
