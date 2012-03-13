require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_puid" do

      let(:runn){ runner(Prog.new :puid => 17) }

      it 'pushes the puid on top of the stack' do
        runn.stack = [:hello]
        runn.op_puid
        runn.stack.should eq([:hello, 17])
      end

    end
  end
end
