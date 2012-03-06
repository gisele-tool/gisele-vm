require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_def" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
        gts.ith_state(0).initial!
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

      let :expected do
        VM::Gts.new do
          add_state :kind =>:event, :initial => true
          add_state :kind => :fork
          add_state :kind => :event
          add_state :kind => :listen, :accepting => true
          add_state :kind => :event
          add_state :kind => :end, :accepting => true
          add_state :kind => :join, :accepting => true
          add_state :kind => :event
          add_state :kind => :end, :accepting => true
          connect 0, 1, :symbol => :start, :event_args => [ "Main" ]
          connect 1, 2, :symbol => :"(forked)"
          connect 2, 3, :symbol => :start, :event_args => [ "Hello" ]
          connect 3, 4, :symbol => :ended
          connect 4, 5, :symbol => :end,   :event_args => [ "Hello" ]
          connect 5, 6, :symbol => :"(notify)"
          connect 1, 6, :symbol => :"(wait)"
          connect 6, 7, :symbol => nil
          connect 7, 8, :symbol => :end, :event_args => [ "Main" ]
        end
      end

      it 'generates an equivalent transition system' do
        gts.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
