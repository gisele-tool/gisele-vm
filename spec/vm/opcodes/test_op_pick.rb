require 'spec_helper'
module Gisele
  class VM
    describe 'op_pick' do

      let(:vm){ VM.new 0, [] }

      subject{
        vm.op_pick
        vm.stack.last
      }

      context 'when a scheduled Prog exists' do

        before do
          @puid0 = vm.proglist.save(Prog.new(:progress => false))
          @puid1 = vm.proglist.save(Prog.new(:progress => true))
        end

        it 'returns a Prog' do
          subject.should be_a(Prog)
        end

        it 'returns a scheduled Prog' do
          subject.progress.should be_true
          subject.puid.should eq(@puid1)
        end

      end

      context 'when a no scheduled Prog exists' do

        before do
          @puid0 = vm.proglist.save(Prog.new(:progress => false))
          @puid1 = vm.proglist.save(Prog.new(:progress => false))
        end

        it 'returns a Prog' do
          pending{ subject.should be_a(Prog) }
        end

        it 'returns a scheduled Prog' do
          pending{
            subject.progress.should be_true
            subject.puid.should eq(@puid1)
          }
        end

      end

    end
  end
end
