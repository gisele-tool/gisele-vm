require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "schedule_at macro" do

      let(:kern)  { kernel(@parent)     }
      let(:parent){ list.fetch(@parent) }

      before do
        @parent = list.save Prog.new(:waitfor => :none)
        subject
      end

      subject do
        kern.run(:schedule_at, [ :s16 ])
      end

      after do
        kern.stack.should be_empty
      end

      it 'resumes the current Prog' do
        parent.waitfor.should eq(:enacter)
        parent.pc.should eq(:s16)
        parent.waitlist.should eq({})
      end

    end
  end
end
