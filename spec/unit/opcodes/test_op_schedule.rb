require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_schedule" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.proglist.save Prog.new
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'sets the progress flag to true' do
        @at0.progress.should be_false
        vm.op_schedule
        @at0.progress.should be_true
      end

      it 'does not touch the original' do
        vm.proglist.fetch(0).progress.should be_false
        vm.op_schedule
        vm.proglist.fetch(0).progress.should be_false
      end

    end
  end
end
