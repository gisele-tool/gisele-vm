require 'spec_helper'
module Gisele
  class VM
    describe "kernel::join" do

      let(:list)  { ProgList.memory                       }
      let(:vm)    { VM.new @parent, Bytecode.kernel, list }
      let(:parent){ list.fetch(@parent)                   }

      before do
        @parent = list.save Prog.new(:pc => :join, :waitlist => wlist)
        subject
      end

      subject do
        vm.run(:join, [ {:wake => :wakeat} ])
      end

      context 'when the waitlist is not empty' do
        let(:wlist){ {12 => true, 13 => true} }

        it 'keeps the program sleeping' do
          parent.pc.should eq(:join)
          parent.progress.should be_false
          pending{ vm.stack.should be_empty }
        end
      end

      context 'when the waitlist is empty' do
        let(:wlist){ {} }

        after do
          vm.stack.should be_empty
        end

        it 'schedules the program at :wakeat' do
          parent.pc.should eq(:wakeat)
          parent.waitlist.should eq({})
          parent.progress.should be_true
        end
      end

    end
  end
end
