require 'spec_helper'
module Gisele
  class VM
    describe "op_nop" do

      let(:vm){ VM.new(nil, []) }

      subject{
        vm.op_nop
        vm.stack
      }

      it 'does nothing' do
        vm.stack = [ 12 ]
        subject.should eq([ 12 ])
      end

    end
  end
end
