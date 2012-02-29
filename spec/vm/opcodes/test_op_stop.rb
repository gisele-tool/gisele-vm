require 'spec_helper'
module Gisele
  class VM
    describe "op_stop" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.save Prog.new(:start => true)
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'sets the start flag to false' do
        @at0.start.should be_true
        vm.op_stop
        @at0.start.should be_false
      end

      it 'does not touch the original' do
        vm.proglist.fetch(0).start.should be_true
        vm.op_stop
        vm.proglist.fetch(0).start.should be_true
      end

    end
  end
end
