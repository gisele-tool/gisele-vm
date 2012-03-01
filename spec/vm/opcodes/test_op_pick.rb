require 'spec_helper'
module Gisele
  class VM
    describe 'op_pick' do

      let(:vm){ VM.new 0, [], ProgList::Blocking.new(ProgList.memory) }

      context 'when a scheduled Prog exists' do

        subject{
          vm.op_pick
          vm.stack.last
        }

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

        subject{
          called = false
          Thread.new(vm.proglist){|l|
            sleep(0.01) until called
            l.save l.fetch(@puid1).tap{|p| p.progress = true}
          }
          vm.op_pick{ called = true }
          vm.stack.last
        }

        before do
          @puid0 = vm.proglist.save(Prog.new(:progress => false))
          @puid1 = vm.proglist.save(Prog.new(:progress => false))
        end

        it 'returns a scheduled Prog' do
          subject.should be_a(Prog)
          subject.progress.should be_true
          subject.puid.should eq(@puid1)
        end

      end

    end
  end
end
