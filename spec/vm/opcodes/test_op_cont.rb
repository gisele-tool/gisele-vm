require 'spec_helper'
module Gisele
  class VM
    describe "op_cont" do

      let(:list){ ProgList.memory        }
      let(:vm)  { VM.new @puid, [], list }

      before {
        @puid = list.save Prog.new(:parent => 17, :progress => true)
      }

      context 'with a label' do

        before do
          vm.stack = [ ]
          vm.op_cont(:somewhere)
        end

        subject{
          vm.stack.size.should eq(1)
          vm.stack.last
        }

        it 'sets the resulting prog on the stack' do
          subject.should be_a(Prog)
        end

        it 'is the current Prog' do
          subject.puid.should eq(@puid)
          subject.parent.should eq(17)
        end

        it 'is not scheduled' do
          subject.progress.should be_false
        end

        it 'has the correct program counter' do
          subject.pc.should eq(:somewhere)
        end

        it 'is not saved' do
          list.fetch(@puid).pc.should eq(0)
          list.fetch(@puid).progress.should be_true
        end

      end # with a label

      context 'without label' do

        before do
          vm.stack = [ :somewhere_else ]
          vm.op_cont
        end

        subject{
          vm.stack.size.should eq(1)
          vm.stack.last
        }

        it 'takes the label from the stack' do
          subject.pc.should eq(:somewhere_else)
        end

      end # without label

    end
  end
end
