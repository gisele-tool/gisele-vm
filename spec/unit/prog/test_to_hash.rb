require 'spec_helper'
module Gisele
  class VM
    describe Prog, 'to_hash' do

      let(:h){ {:puid => 17, :parent => 16, :root => 8} }
      let(:prog){ Prog.new(h) }

      context 'without argument' do
        subject do
          prog.to_hash
        end
        it 'returns the whole hash' do
          subject.size.should eq(7)
        end
      end

      context 'with some keys only' do
        subject do
          prog.to_hash([:puid, :parent, :root])
        end
        it 'returns a projection' do
          subject.should eq(h)
        end
      end

    end
  end
end
