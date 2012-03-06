require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_def" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
      end

      subject do
        code = <<-GIS.strip
          seq
            Ping
            Pong
          end
        GIS
        compiler.call(Gisele.sexpr(Gisele.parse(code, :root => :seq_st)))
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      it 'generates valid task states' do
        entry, exit = subject
        entry[:kind].should eq(:nop)
         exit[:kind].should eq(:nop)
      end

      it 'parses a trace that waits twice' do
        trace = [:"(wait)", :"(wait)"]
        gts.parse?(trace, 0).should be_true
      end

      it 'waits in wait states' do
        gts.accept?([:"(wait)"], 0).should be_true
        gts.accept?([:"(wait)", :"(wait)"], 0).should be_true
      end

      it 'parses a trace that forks twice' do
        trace = [:"(forked)", :"start", :ended, :"end", :"(notify)"]
        trace += trace
        gts.parse?(trace, 0).should be_true
      end

      it 'adds event arguments on :start and :end' do
        gts.edges.select{|s| [:start, :end].include?(s.symbol)}.each do |e|
          e[:event_args].should be_a(Array)
        end
      end

    end
  end
end
