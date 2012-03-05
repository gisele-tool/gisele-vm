require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_call_st" do

      let(:gts)     { Stamina::Automaton.new      }
      let(:compiler){ Gisele2Gts.new(:gts => gts) }

      before do
        subject
      end

      subject do
        compiler.call(Gisele.sexpr(Gisele.parse("Hello", :root => :task_call_st)))
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      it 'should generate valid fork/join pairs' do
        entry, exit = subject
        entry[:kind].should eq(:fork)
        exit[:kind].should  eq(:join)
        entry[:join].should eq(exit.index)
      end

      it 'should actually generate 6 states' do
        gts.states.size.should eq(6)
      end

    end
  end
end
