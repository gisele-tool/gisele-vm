require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "schedule_at macro" do

      let(:list)  { ProgList.memory                           }
      let(:vm)    { Kernel.new @parent, Bytecode.kernel, list }
      let(:parent){ list.fetch(@parent)                       }

      before do
        @parent = list.save Prog.new(:progress => false, :waitfor => :none)
        subject
      end

      subject do
        vm.run(:schedule_at, [ :s16 ])
      end

      after do
        vm.stack.should be_empty
      end

      it 'resumes the current Prog' do
        parent.progress.should be_true
        parent.waitfor.should eq(:enacter)
        parent.pc.should eq(:s16)
        parent.waitlist.should eq({})
      end

    end
  end
end
