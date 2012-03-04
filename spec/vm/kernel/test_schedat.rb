require 'spec_helper'
module Gisele
  class VM
    describe "kernel::schedat" do

      let(:vm){ VM.new 0, Bytecode.kernel }

      before do
        @puid = vm.proglist.save Prog.new(:progress => false)
      end

      subject{
        vm.run(:schedat, [ :s16 ])
        vm.stack
      }

      it 'sleeps the current Prog' do
        subject.should eq([ ])
        prog = vm.proglist.fetch(@puid)
        prog.progress.should be_true
        prog.pc.should eq(:s16)
        prog.waitlist.should eq({})
      end

    end
  end
end
