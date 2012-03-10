require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_self" do

      let(:runn){ runner(@puid) }

      before do
        @puid = list.save Prog.new
      end

      it 'puts the current prog on the stack' do
        runn.stack = [ ]
        runn.op_self
        runn.stack.should eq([ list.fetch(@puid) ])
      end

    end
  end
end
