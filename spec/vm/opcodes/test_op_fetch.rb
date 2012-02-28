require 'spec_helper'
module Gisele
  class VM
    describe "op_fetch" do

      let(:vm){ VM.new 0, [] }

      before do
        vm.proglist.register Prog.new
        vm.proglist.register Prog.new
        @at1 = vm.proglist.fetch(1)
        @at1.should be_a(Prog)
      end

      it 'fetches with the uuid' do
        vm.stack = [ 1 ]
        vm.op_fetch
        vm.stack.should eq([ @at1 ])
      end

    end
  end
end
