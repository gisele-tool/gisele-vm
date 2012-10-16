require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_unit_def" do

      subject do
        code = <<-GIS.strip
          task Ping
            Helli
          end
        GIS
        Gisele2Gts.compile code.strip
      end

      let :expected do
        ping = Gisele2Gts.compile("task Ping Helli end", :root => :task_def)
        Gts.new do
          s0 = add_state :kind => :launch, :initial => true
          s1 = add_state :kind => :end, :accepting => true
          ping.dup(self) do |source,target|
            connect(s0, target, :symbol => :Ping) if source.in_edges.empty?
            connect(target, s1, :symbol => nil)   if source.out_edges.empty?
          end
        end
      end

      it 'generates an equivalent transition system' do
        # (Path.pwd/'examples/gts.dot').write gts.to_dot
        # (Path.pwd/'examples/expected.dot').write expected.to_dot
        subject.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
