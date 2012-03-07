require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_self" do

      let(:kern){ kernel(@puid) }

      before do
        @puid = list.save Prog.new
      end

      it 'puts the current prog on the stack' do
        kern.stack = [ ]
        kern.op_self
        kern.stack.should eq([ list.fetch(@puid) ])
      end

    end
  end
end
