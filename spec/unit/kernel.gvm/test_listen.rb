require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "listen macro" do

      let(:kern)  { kernel(@parent)     }
      let(:parent){ list.fetch(@parent) }
      let(:wlist) { {:ping => :sPing, :pong => :sPong}        }

      before do
        @parent = list.save Prog.new(:pc => :listen)
        subject
      end

      subject do
        kern.run(:listen, [ wlist ])
      end

      after do
        kern.stack.should be_empty
      end

      it 'sets the events as waitlist' do
        parent.waitlist.should eq(wlist)
      end

      it 'sets the program counter to :react' do
        parent.pc.should eq(:react)
      end

      it 'unschedules the current Prog' do
        parent.waitfor.should eq(:world)
      end

    end
  end
end
