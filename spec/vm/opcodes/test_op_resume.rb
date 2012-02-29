require 'spec_helper'
module Gisele
  class VM
    describe "op_resume" do

      let(:vm){ VM.new :test_pushc, [[:at_0], [:hello, :world]] }

      before do
        vm.proglist.save Prog.new(:wait => waitlist)
        vm.stack = [ vm.proglist.fetch(0), 1 ]
      end

      context "when the waitlist is empty" do
        let(:waitlist){ [] }

        it 'resumes through pushc' do
          vm.op_resume
          vm.opcodes.should eq([:hello, :world])
          vm.stack.should eq([ vm.proglist.fetch(0) ])
        end
      end

      context "when the waitlist is not empty" do
        let(:waitlist){ [12] }

        it 'does not resume' do
          vm.op_resume
          vm.opcodes.should eq([])
          vm.stack.should eq([ vm.proglist.fetch(0) ])
        end
      end

    end
  end
end
