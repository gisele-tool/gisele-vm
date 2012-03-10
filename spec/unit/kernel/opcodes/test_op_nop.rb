require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_nop" do

      subject do
        runner.op_nop
        runner.stack
      end

      it 'does nothing' do
        runner.stack = [ 12 ]
        subject.should eq([ 12 ])
      end

    end
  end
end
