require 'spec_helper'
module Gisele
  class VM
    describe "kernel::sleep" do

      let(:vm){ VM.new 0, Bytecode.kernel }

      before do
        @puid = vm.proglist.save Prog.new(:progress => true)
      end

      subject{
        vm.run(:sleep, [ 12 ])
        vm.stack
      }

      it 'sleeps the current Prog' do
        subject.should eq([12])
        vm.proglist.fetch(@puid).progress.should be_false
      end

    end
  end
end
