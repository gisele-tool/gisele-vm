require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fork" do

      let(:vm){ Kernel.new nil, [], 17 }

      context 'with a label' do

        before do
          vm.stack = [ ]
          vm.op_fork(:somewhere)
        end

        subject{
          vm.stack.size.should eq(1)
          vm.stack.last
        }

        it 'sets the resulting prog on the stack' do
          subject.should be_a(Prog)
        end

        it 'is a child Prog' do
          subject.parent.should eq(17)
        end

        it 'is scheduled' do
          subject.waitfor.should eq(:enacter)
        end

        it 'has the correct program counter' do
          subject.pc.should eq(:somewhere)
        end

        it 'is not registered yet' do
          subject.puid.should be_nil
        end

      end # with a label

      context 'without label' do

        before do
          vm.stack = [ :somewhere_else ]
          vm.op_fork
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
