require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_end" do

      let(:list){ ProgList.memory        }
      let(:vm)  { Kernel.new @puid, [], list }

      before {
        @puid = list.save Prog.new(:parent => 17, :progress => true)
      }

      subject{
        vm.stack = [ ]
        vm.op_end
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
        subject.pc.should eq(-1)
      end

      it 'is not saved' do
        list.fetch(@puid).pc.should eq(0)
        list.fetch(@puid).progress.should be_true
      end

    end
  end
end
