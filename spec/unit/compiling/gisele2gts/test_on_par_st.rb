require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_par_st" do

      before do
        subject.ith_state(0).initial!
      end

      subject do
        code = <<-GIS.strip
          par
            Ping
            Pong
          end
        GIS
        Gisele2Gts.compile code.strip, :root => :par_st
      end

      let :expected do
        ping = Gisele2Gts.compile("Ping", :root => :task_call_st)
        pong = Gisele2Gts.compile("Pong", :root => :task_call_st)
        Gts.new do
          s0 = add_state :kind => :fork, :initial => true
          s1 = add_state :kind => :end, :accepting => true
          s2 = add_state :kind => :end, :accepting => true
          s3 = add_state :kind => :join, :accepting => true
          connect(s0, s3, :symbol => :"(wait)")

          ping.dup(self) do |source,target|
            connect(s0, target, :symbol => :"(forked#0)") if source.in_edges.empty?
            connect(target, s1, :symbol => :"(joined)")   if source.out_edges.empty?
          end
          pong.dup(self) do |source,target|
            connect(s0, target, :symbol => :"(forked#1)") if source.in_edges.empty?
            connect(target, s2, :symbol => :"(joined)")   if source.out_edges.empty?
          end
          connect(s1, s3, :symbol => :"(notify)")
          connect(s2, s3, :symbol => :"(notify)")
        end
      end

      it 'generates an equivalent transition system' do
        # (Path.pwd/'examples/gts.dot').write subject.to_dot
        # (Path.pwd/'examples/expected.dot').write expected.to_dot
        subject.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
