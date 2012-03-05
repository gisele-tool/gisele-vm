require 'spec_helper'
module Gisele
  class VM
    describe Prog, 'merge' do

      let(:left){
        Prog.new(:puid => 17, :parent => 1, :waitlist => {12 => false, 28 => false})
      }
      let(:right){
        {:puid => 18, :waitlist => {12 => true, 17 => false} }
      }

      subject{ left.merge(right) }

      it 'returns a Prog' do
        subject.should be_a(Prog)
      end

      it 'returns a different Prog' do
        subject.object_id.should_not eq(left.object_id)
      end

      it 'sets the attributes correctly' do
        subject.puid.should eq(18)
        subject.parent.should eq(1)
        subject.waitlist.should eq({12 => true, 17 => false, 28 => false})
      end

    end
  end
end
