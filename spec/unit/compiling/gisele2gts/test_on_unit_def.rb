require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_unit_def" do

      let(:compiler){ Gisele2Gts.new }
      let(:gts)     { compiler.gts   }

      before do
        subject
      end

      subject do
        code = <<-GIS.strip
          task Ping
            Helli
          end
          task Pong
            Hello
          end
        GIS
        compiler.call Gisele.sexpr(code.strip)
      end

      it 'returns a pair of states' do
        subject.should be_a(Array)
        subject.size.should eq(2)
        subject.each{|s| s.should be_a(Stamina::Automaton::State) }
      end

      let :expected do
        ping = Gisele.parse("task Ping Helli end", :root => :task_def)
        ping = Gisele.sexpr(ping)
        ping = Gisele2Gts.compile(ping)
        pong = Gisele.parse("task Pong Hello end", :root => :task_def)
        pong = Gisele.sexpr(pong)
        pong = Gisele2Gts.compile(pong)
        VM::Gts.new do
          s0 = add_state :kind => :event, :initial => true
          s1 = add_state :kind => :end, :accepting => true
          ping.dup(self) do |source,target|
            connect(s0, target, :symbol => :Ping) if source.in_edges.empty?
            connect(target, s1, :symbol => nil)   if source.out_edges.empty?
          end
          pong.dup(self) do |source,target|
            connect(s0, target, :symbol => :Pong) if source.in_edges.empty?
            connect(target, s1, :symbol => nil)   if source.out_edges.empty?
          end
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
