require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fork" do

      let(:vm){ Kernel.new 17, [] }

      after do
        top = vm.stack.last
        top.should be_a(Array)
        top.size.should eq(2)
        top.each{|p| p.should be_a(Prog)}
        top.each{|p|
          p.parent.should eq(17)
          p.waitfor.should eq(:enacter)
          p.puid.should be_nil
        }
        top.map{|p| p.pc}.should eq([:s0, :s1])
      end

      context 'with an array of labels' do

        subject do
          vm.stack = [ ]
          vm.op_forka([ :s0, :s1 ])
        end

        it 'puts the resulting array on the stack' do
          subject
          vm.stack.size.should eq(1)
        end

      end # with a label

      context 'without argument' do

        subject do
          vm.stack = [ [:s0, :s1] ]
          vm.op_forka
        end

        it 'takes the labels from the stack' do
          subject
          vm.stack.size.should eq(1)
        end

      end # without label

    end
  end
end
