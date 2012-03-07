require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_end" do

      let(:list){ ProgList.memory            }
      let(:vm)  { Kernel.new @puid, [], list }
      let(:prog){ vm.stack.last              }

      before {
        @puid = list.save Prog.new(:parent => 17, :progress => true, :waitfor => :enacter)
        subject
      }

      subject do
        vm.op_end
      end

      it 'sets the resulting prog on the stack' do
        prog.should be_a(Prog)
      end

      it 'is the current Prog' do
        prog.puid.should eq(@puid)
        prog.parent.should eq(17)
      end

      it 'is not scheduled' do
        prog.progress.should be_false
        prog.waitfor.should eq(:none)
      end

      it 'has the correct program counter' do
        prog.pc.should eq(-1)
      end

      it 'is not saved' do
        list.fetch(@puid).pc.should eq(0)
        list.fetch(@puid).progress.should be_true
      end

    end
  end
end
