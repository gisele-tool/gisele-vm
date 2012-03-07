require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_then" do

      it 'pushes opcodes on the code stack' do
        kernel.bytecode = [ [:at_0], [:hello, :world] ]
        kernel.opcodes  = [ :begin ]
        kernel.stack    = [ :prev, 1 ]
        kernel.op_then
        kernel.opcodes.should eq([:begin, :hello, :world])
        kernel.stack.should eq([:prev])
      end

    end
  end
end
