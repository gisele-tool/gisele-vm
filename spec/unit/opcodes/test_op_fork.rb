require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fork" do

      let(:kern){ kernel(Prog.new :puid => 17) }

      context 'with a label' do

        before do
          kern.stack = [ ]
          kern.op_fork(:somewhere)
        end

        subject{
          kern.stack.size.should eq(1)
          kern.stack.last
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
          kern.stack = [ :somewhere_else ]
          kern.op_fork
        end

        subject{
          kern.stack.size.should eq(1)
          kern.stack.last
        }

        it 'takes the label from the stack' do
          subject.pc.should eq(:somewhere_else)
        end

      end # without label

    end
  end
end
