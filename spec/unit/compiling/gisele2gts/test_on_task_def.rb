require 'spec_helper'
module Gisele
  module Compiling
    describe Gisele2Gts, "on_task_def" do

      before do
        subject
        subject.ith_state(0).initial!
      end

      subject do
        code = <<-GIS.strip
          task Main
            Hello
          end
        GIS
        Gisele2Gts.compile(code, :root => :task_def)
      end

      let :expected do
        Gts.new do
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
        subject.bytecode_equivalent!(expected).should be_true
      end

    end
  end
end
