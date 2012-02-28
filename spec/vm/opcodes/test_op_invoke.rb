require 'spec_helper'
module Gisele
  class VM
    describe "op_invoke" do

      let(:vm){ VM.new 0, [] }

      def hello(*args)
        @args = args
      end

      it 'pushes the result on the stack' do
        vm.stack = [ self, :hello, [ "world", "!" ] ]
        vm.op_invoke
        @args.should eq(["world", "!"])
        vm.stack.should eq([ ])
      end

    end
  end
end
