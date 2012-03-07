require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fetch" do

      let(:vm){ Kernel.new 0, [] }

      before do
        vm.proglist.save Prog.new
        vm.proglist.save Prog.new
        @at1 = vm.proglist.fetch(1)
      end

      it 'fetches the correct Prog' do
        vm.op_fetch(1)
        vm.stack.should eq([ @at1 ])
      end

      it 'supports taking the puid from the stack' do
        vm.stack = [ 1 ]
        vm.op_fetch
        vm.stack.should eq([ @at1 ])
      end

    end
  end
end
