require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_unschedule" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.proglist.save Prog.new(:progress => true)
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'sets the progress flag to false' do
        @at0.progress.should be_true
        vm.op_unschedule
        @at0.progress.should be_false
      end

      it 'does not touch the original' do
        vm.proglist.fetch(0).progress.should be_true
        vm.op_unschedule
        vm.proglist.fetch(0).progress.should be_true
      end

    end
  end
end
