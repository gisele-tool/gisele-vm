require 'spec_helper'
module Gisele
  class VM
    describe "op_notify" do

      let(:list){ ProgList.memory }

      before do
        @puid0 = list.save Prog.new(:progress => false)
        @puid1 = list.save Prog.new(:parent => @puid0)
        @at1   = list.fetch(@puid1)
      end

      let(:vm){ VM.new(@puid1, [], list) }

      subject{ vm.stack.last }

      context 'when it leads to a non-empty wait list' do

        before do
          @at0 = list.fetch(@puid0)
          @at0.waitlist = [ 12, 16, @puid1 ]
          list.save(@at0)
          vm.stack = [ ]
          vm.op_notify
        end

        it 'puts the parent Prog on the stack' do
          subject.should be_a(Prog)
          subject.puid.should eq(@puid0)
        end

        it 'removes the child puid from its wait list' do
          subject.waitlist.should eq([ 12, 16 ])
        end

        it 'does not schedule the parent' do
          subject.progress.should be_false
        end

      end # non-empty wait list

      context 'when it leads to an empty wait list' do

        before do
          @at0 = list.fetch(@puid0)
          @at0.waitlist = [ @puid1 ]
          list.save(@at0)
          vm.stack = [ ]
          vm.op_notify
        end

        it 'puts the parent Prog on the stack' do
          subject.should be_a(Prog)
          subject.puid.should eq(@puid0)
        end

        it 'removes the child puid from its wait list' do
          subject.waitlist.should eq([ ])
        end

        it 'schedules the parent' do
          subject.progress.should be_true
        end

      end # empty wait list

    end
  end
end
