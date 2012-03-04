require 'spec_helper'
module Gisele
  class VM
    describe "kernel::notify" do

      let(:vm) { VM.new 1, Bytecode.kernel }

      before do
        @parent = vm.proglist.save Prog.new(:waitlist => {1 => true, 2 => true})
        @child  = vm.proglist.save Prog.new(:parent => @parent)
      end

      subject{
        vm.run(:notify, [ ])
        vm.proglist.fetch(@child)
      }

      it 'ends the child' do
        subject.pc.should eq(-1)
        subject.progress.should be_false
      end

      it 'resumes the parent on a reduced waitlist' do
        subject
        parent = vm.proglist.fetch(@parent)
        parent.waitlist.should eq(2 => true)
        parent.progress.should be_true
      end

    end
  end
end
