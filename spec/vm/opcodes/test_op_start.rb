require 'spec_helper'
module Gisele
  class VM
    describe "op_start" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.register Prog.new
        @at0 = vm.proglist.fetch(0)
        vm.stack = [ @at0 ]
      end

      it 'sets the start flag to true' do
        @at0.start.should be_false
        vm.op_start
        @at0.start.should be_true
      end

      it 'does not touch the original' do
        vm.proglist.fetch(0).start.should be_false
        vm.op_start
        vm.proglist.fetch(0).start.should be_false
      end

    end
  end
end