require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fetch" do

      before do
        @parent = list.save Prog.new
        @child  = list.save Prog.new
        @at1    = list.fetch(@child)
      end

      after do
        runner.stack.should eq([ @at1 ])
      end

      it 'fetches the correct Prog with an arg' do
        runner.op_fetch(@child)
      end

      it 'supports taking the puid from the stack' do
        runner.stack = [ @child ]
        runner.op_fetch
      end

    end
  end
end
