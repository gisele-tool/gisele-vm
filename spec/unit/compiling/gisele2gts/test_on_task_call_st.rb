require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_call_st" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
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

      it 'generates valid fork/join pairs' do
        entry, exit = subject
        entry[:kind].should eq(:fork)
         exit[:kind].should eq(:join)
      end

      it 'generates 6 states' do
        gts.states.size.should eq(6)
      end

      it 'parses a whole trace' do
        gts.parse?([:"(forked)", :start, :ended, :end, :"(notify)"], 0).should be_true
      end

      it 'waits in listen states' do
        gts.accept?([:"(forked)", :start], 0).should be_true
      end

      it 'waits at the end' do
        gts.accept?([:"(forked)", :start, :ended, :end, :"(notify)"], 0).should be_true
      end

      it 'adds event arguments on :start and :end' do
        gts.edges.select{|s| [:start, :end].include?(s.symbol)}.each do |e|
          e[:event_args].should be_a(Array)
        end
      end

    end
  end
end
