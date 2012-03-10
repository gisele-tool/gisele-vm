require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "join macro" do

      let(:runn)  { runner(@parent)     }
      let(:parent){ list.fetch(@parent) }

      before do
        @parent = list.save Prog.new(:pc => :blah, :waitlist => wlist, :waitfor => :enacter)
        subject
      end

      subject do
        runn.run(:join, [ {:wake => :wakeat} ])
      end

      after do
        runn.stack.should be_empty
      end

      context 'when the waitlist is not empty' do
        let(:wlist){ {12 => true, 13 => true} }

        it 'keeps the program sleeping' do
          parent.pc.should eq(:blah)
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
