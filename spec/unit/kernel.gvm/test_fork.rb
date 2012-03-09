require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "fork macro" do

      let(:kern)  { kernel(@parent)     }
      let(:parent){ list.fetch(@parent) }

      before do
        @parent = list.save Prog.new(:pc => :fork, :root => 16)
        subject
      end

      subject do
        kern.run(:fork, [ :joinat, [ :fat1, :fat2 ] ])
      end

      after do
        kern.stack.should be_empty
      end

      it 'sets the events as waitlist' do
        parent.waitlist.should eq({1 => true, 2 => true})
      end

      it 'fork and schedules self and children correctly' do
        expected = Relation([
          {:puid => 0, :pc => :joinat, :parent => 0, :root => 16, :waitfor => :children},
          {:puid => 1, :pc => :fat1,   :parent => 0, :root => 16, :waitfor => :enacter },
          {:puid => 2, :pc => :fat2,   :parent => 0, :root => 16, :waitfor => :enacter }
        ])
        list.to_relation.project([:puid, :pc, :parent, :root, :waitfor]).should eq(expected)
      end

    end
  end
end
