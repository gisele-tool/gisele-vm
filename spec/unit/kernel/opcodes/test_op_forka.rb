require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_fork" do

      let(:runn){ runner(Prog.new :puid => 17) }

      after do
        top = runn.stack.last
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
          runn.stack = [ ]
          runn.op_forka([ :s0, :s1 ])
        end

        it 'puts the resulting array on the stack' do
          subject
          runn.stack.size.should eq(1)
        end

      end # with a label

      context 'without argument' do

        subject do
          runn.stack = [ [:s0, :s1] ]
          runn.op_forka
        end

        it 'takes the labels from the stack' do
          subject
          runn.stack.size.should eq(1)
        end

      end # without label

    end
  end
end
