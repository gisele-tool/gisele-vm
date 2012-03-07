require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_seq_def" do

      before do
        subject.ith_state(0).initial!
      end

      subject do
        code = <<-GIS.strip
          seq
            Ping
            Pong
          end
        GIS
        Gisele2Gts.compile code.strip, :root => :seq_st
      end

      let :expected do
        ping = Gisele2Gts.compile("Ping", :root => :task_call_st)
        pong = Gisele2Gts.compile("Pong", :root => :task_call_st)
        Gts.new do
          s0 = add_state :kind => :nop, :initial => true
          s1 = add_state :kind => :nop
          ping_end = nil
          ping.dup(self) do |source,target|
            connect(s0, target, :symbol => nil) if source.in_edges.empty?
            ping_end = target if source.out_edges.empty?
          end
          pong.dup(self) do |source,target|
            connect(ping_end, target, :symbol => nil) if source.in_edges.empty?
            connect(target, s1, :symbol => nil)       if source.out_edges.empty?
          end
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
