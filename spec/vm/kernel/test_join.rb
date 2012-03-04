require 'spec_helper'
module Gisele
  class VM
    describe "kernel::join" do

      let(:vm) { VM.new 0, Bytecode.kernel }

      before do
        prog  = Prog.new(:pc => :join, :waitlist => wlist)
        @puid = vm.proglist.save(prog)
      end

      subject{
        vm.run(:join, [ {:wake => :wakeat} ])
        vm.proglist.fetch(@puid)
      }

      context 'when the waitlist is not empty' do
        let(:wlist){ {12 => true, 13 => true} }

        it 'keeps the program sleeping' do
          subject.pc.should eq(:join)
          subject.progress.should be_false
        end
      end

      context 'when the waitlist is empty' do
        let(:wlist){ {} }

        it 'schedules the program at :wakeat' do
          subject.pc.should eq(:wakeat)
          subject.waitlist.should eq({})
          subject.progress.should be_true
        end
      end

    end
  end
end
