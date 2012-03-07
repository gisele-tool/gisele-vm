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
        kernel.stack.should eq([ @at1 ])
      end

      it 'fetches the correct Prog with an arg' do
        kernel.op_fetch(1)
      end

      it 'supports taking the puid from the stack' do
        kernel.stack = [ 1 ]
        kernel.op_fetch
      end

    end
  end
end
