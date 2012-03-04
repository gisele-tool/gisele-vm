require 'spec_helper'
module Gisele
  class VM
    describe "op_wait" do

      let(:vm){ VM.new 0, [] }

      before do
        @puid0 = vm.proglist.save Prog.new(:progress => true)
        @puid1 = vm.proglist.save Prog.new
        @puid2 = vm.proglist.save Prog.new
        @at0   = vm.proglist.fetch(@puid0)
        @at1   = vm.proglist.fetch(@puid1)
        @at2   = vm.proglist.fetch(@puid2)
      end

      before do
        vm.stack = [ @puid0, @puid1, @puid2 ]
        vm.op_wait(arg)
      end

      subject{
        vm.stack.last
      }

      context 'without arg' do
        let(:arg){ nil }

        it 'puts the resulting Prog on the stack' do
          subject.should be_a(Prog)
        end

        it 'puts the last puid in the wait list' do
          subject.waitlist.should eq([ @puid2 ])
        end

        it 'unschedules the parent' do
          subject.progress.should be_false
        end

        it 'removes the waited puid from the stack' do
          vm.stack.should eq([ @puid0, @puid1, subject ])
        end
      end

      context 'with an integer arg' do
        let(:arg){ 2 }

        it 'puts the resulting Prog on the stack' do
          subject.should be_a(Prog)
        end

        it 'puts the poped puids in the wait list' do
          subject.waitlist.should eq([ @puid2, @puid1 ])
        end

        it 'unschedules the parent' do
          subject.progress.should be_false
        end

        it 'removes the waited puids from the stack' do
          vm.stack.should eq([ @puid0, subject ])
        end
      end

      context 'with 0' do
        let(:arg){ 0 }

        it 'puts the resulting Prog on the stack' do
          subject.should be_a(Prog)
        end

        it 'puts the poped puids in the wait list' do
          subject.waitlist.should eq([ ])
        end

        it 'schedules the parent' do
          subject.progress.should be_true
        end

        it 'does not remove any puid from the stack' do
          vm.stack.should eq([ @puid0, @puid1, @puid2, subject ])
        end
      end

    end
  end
end
