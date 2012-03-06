require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_call_st" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
        gts.ith_state(0).initial!
      end

      subject do
        sexpr = Gisele.sexpr(Gisele.parse("Hello", :root => :task_call_st))
        compiler.call(sexpr)
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      let :expected do
        VM::Gts.new do
          add_state :kind => :fork,   :initial => true
          add_state :kind => :event
          add_state :kind => :listen, :accepting => true
          add_state :kind => :event
          add_state :kind => :end,    :accepting => true
          add_state :kind => :join,   :accepting => true
          connect 0, 1, :symbol => :"(forked)"
          connect 1, 2, :symbol => :start, :event_args => [ "Hello" ]
          connect 2, 3, :symbol => :ended
          connect 3, 4, :symbol => :end,   :event_args => [ "Hello" ]
          connect 4, 5, :symbol => :"(notify)"
          connect 0, 5, :symbol => :"(wait)"
        end
      end

      it 'generates an equivalent transition system' do
        gts.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
