require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "fork macro" do

      let(:runn)  { runner(@parent)     }
      let(:parent){ list.fetch(@parent) }

      before do
        @parent = list.save Prog.new(:pc => :fork, :root => 16)
        subject
      end

      subject do
        runn.run(:fork, [ :joinat, [ :fat1, :fat2 ] ])
      end

      after do
        runn.stack.should be_empty
      end

      it 'sets the events as waitlist' do
        parent.waitlist.should eq({@parent+1 => true, @parent+2 => true})
      end

      it 'fork and schedules self and children correctly' do
        expected = Relation([
          {:puid => @parent,   :pc => :joinat, :parent => @parent, :root => 16, :waitfor => :children},
          {:puid => @parent+1, :pc => :fat1,   :parent => @parent, :root => 16, :waitfor => :enacter },
          {:puid => @parent+2, :pc => :fat2,   :parent => @parent, :root => 16, :waitfor => :enacter }
        ])
        list.to_relation.project([:puid, :pc, :parent, :root, :waitfor]).should eq(expected)
      end

    end
  end
end
