require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_puid" do

      let(:kern){ kernel(17) }

      it 'pushes the puid on top of the stack' do
        kern.stack = [:hello]
        kern.op_puid
        kern.stack.should eq([:hello, 17])
      end

    end
  end
end
