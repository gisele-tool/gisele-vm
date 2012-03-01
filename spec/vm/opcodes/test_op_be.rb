require 'spec_helper'
module Gisele
  class VM
    describe "op_be" do
      let(:vm)  { VM.new 0, [] }

      before do
        @prog = Prog.new(:puid => 17)
        vm.stack = [ @prog ]
      end

      subject{
        vm.op_be
        vm
      }

      it 'sets the puid of the VM to the one of the Prog' do
        subject.puid.should eq(17)
      end

      it 'does not touch the stack' do
        subject.stack.should eq([ @prog ])
      end

    end
  end
end
