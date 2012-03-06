require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_par_st" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
        gts.ith_state(0).initial!
      end

      subject do
        code = <<-GIS.strip
          par
            Ping
            Pong
          end
        GIS
        compiler.call(Gisele.sexpr(Gisele.parse(code, :root => :par_st)))
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      let :expected do
        VM::Gts.new do
          add_state :kind => :fork
          add_state :kind => :event
          add_state :kind => :listen, :accepting => true
          add_state :kind => :event
          add_state :kind => :end,    :accepting => true
          add_state :kind => :join,   :accepting => true
          connect 0, 1, :symbol => :"(forked)"
          connect 1, 2, :symbol => :start, :event_args => [ "Ping" ]
          connect 2, 3, :symbol => :ended
          connect 3, 4, :symbol => :end,   :event_args => [ "Ping" ]
          connect 4, 5, :symbol => :"(notify)"
          connect 0, 5, :symbol => :"(wait)"

          add_state :kind => :fork
          add_state :kind => :event
          add_state :kind => :listen, :accepting => true
          add_state :kind => :event
          add_state :kind => :end,    :accepting => true
          add_state :kind => :join,   :accepting => true
          connect 6, 7, :symbol => :"(forked)"
          connect 7, 8, :symbol => :start, :event_args => [ "Pong" ]
          connect 8, 9, :symbol => :ended
          connect 9, 10, :symbol => :end,   :event_args => [ "Pong" ]
          connect 10, 11, :symbol => :"(notify)"
          connect 6, 11, :symbol => :"(wait)"

          add_state :kind => :fork, :initial => true   # 12
          add_state :kind => :end, :accepting => true  # 13
          add_state :kind => :end, :accepting => true  # 14
          add_state :kind => :join, :accepting => true # 15

          connect(12, 15,  :symbol => :"(wait)")
          connect(12, 0,   :symbol => :"(forked#0)")
          connect(12, 6,   :symbol => :"(forked#1)")
          connect(11, 13,  :symbol => :joined)
          connect(5,  14,  :symbol => :joined)
          connect(13, 15,  :symbol => :"(notify)")
          connect(14, 15,  :symbol => :"(notify)")
        end
      end

      it 'generates an equivalent transition system' do
        # (Path.pwd/'examples/gts.dot').write gts.to_dot
        # (Path.pwd/'examples/expected.dot').write expected.to_dot
        gts.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
