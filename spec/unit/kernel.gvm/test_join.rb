require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "join macro" do

      let(:list)  { ProgList.memory                           }
      let(:vm)    { Kernel.new @parent, Bytecode.kernel, list }
      let(:parent){ list.fetch(@parent)                       }

      before do
        @parent = list.save Prog.new(:pc => :join, :waitlist => wlist, :waitfor => :children)
        subject
      end

      subject do
        vm.run(:join, [ {:wake => :wakeat} ])
      end

      after do
        vm.stack.should be_empty
      end

      context 'when the waitlist is not empty' do
        let(:wlist){ {12 => true, 13 => true} }

        it 'keeps the program sleeping' do
          parent.pc.should eq(:join)
          parent.waitfor.should eq(:children)
        end
      end

      context 'when the waitlist is empty' do
        let(:wlist){ {} }

        it 'schedules the program at :wakeat' do
          parent.pc.should eq(:wakeat)
          parent.waitlist.should eq({})
          parent.waitfor.should eq(:enacter)
        end
      end

    end
  end
end
