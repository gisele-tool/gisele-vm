require 'spec_helper'
module Gisele
  class VM
    describe "kernel::listen" do

      let(:vm)   { VM.new 0, Bytecode.kernel          }
      let(:wlist){ {:ping => :sPing, :pong => :sPong} }

      before do
        prog  = Prog.new(:pc => :listen)
        @puid = vm.proglist.save(prog)
      end

      subject{
        vm.run(:listen, [ wlist ])
        vm.stack.should be_empty
        vm.proglist.fetch(@puid)
      }

      it 'sets the events as waitlist' do
        subject.waitlist.should eq(wlist)
      end

      it 'sets the program counter to :react' do
        subject.pc.should eq(:react)
      end

      it 'unschedules the current Prog' do
        subject.progress.should be_false
      end

    end
  end
end
