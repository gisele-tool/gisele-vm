require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_nop" do

      subject do
        kernel.op_nop
        kernel.stack
      end

      it 'does nothing' do
        kernel.stack = [ 12 ]
        subject.should eq([ 12 ])
      end

    end
  end
end
