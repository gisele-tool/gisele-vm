require 'spec_helper'
module Gisele
  class VM
    describe "kernel::react" do

      let(:vm)   { VM.new 0, Bytecode.kernel          }
      let(:wlist){ {:ping => :sPing, :pong => :sPong} }

      before do
        prog  = Prog.new(:pc => :react, :waitlist => wlist)
        @puid = vm.proglist.save(prog)
      end

      subject{
        vm.run(:react, [ event ])
        vm.proglist.fetch(@puid)
      }

      context 'when a recognized event' do
        let(:event){ :ping }

        it 'schedules the current Prog correctly' do
          subject.pc.should eq(:sPing)
          subject.progress.should be_true
          subject.waitlist.should eq({})
          vm.stack.should be_empty
        end
      end

      context 'when an unrecognized event' do
        let(:event){ :pang }

        it 'sleeps the current Prog' do
          subject.pc.should eq(:react)
          subject.progress.should be_false
          subject.waitlist.should eq(wlist)
          vm.stack.should eq([nil])
        end
      end

    end
  end
end
