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
          task Main
            Hello
          end
        GIS
        compiler.call(Gisele.sexpr(Gisele.parse(code, :root => :task_def)))
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      it 'generates valid task states' do
        entry, exit = subject
        entry[:kind].should eq(:event)
         exit[:kind].should  eq(:end)
      end

      it 'parses typical traces' do
        trace = [:start, :forked, :start, :ended, :end, :notify, :end]
        gts.parse?(trace).should be_true
      end

      it 'adds event arguments on :start and :end' do
        gts.edges.select{|s| [:start, :end].include?(s.symbol)}.each do |e|
          e[:event_args].should be_a(Array)
        end
      end

    end
  end
end
