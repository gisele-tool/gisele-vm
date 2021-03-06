require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "notify macro" do

      let(:runn)  { runner(@child)      }
      let(:parent){ list.fetch(@parent) }
      let(:child) { list.fetch(@child)  }

      subject do
        runn.run(:notify, [ ])
      end

      after do
        runn.stack.should be_empty
      end

      context 'when the child has a parent' do

        before do
          @parent = list.save Prog.new
          @child  = list.save Prog.new(:parent => @parent)
          @child2 = list.save Prog.new(:parent => @parent)
          list.save(Prog.new :puid => @parent, :waitlist => {@child => true, @child2 => true})
          subject
        end

        it 'ends the child' do
          child.pc.should eq(-1)
          child.waitfor.should eq(:none)
        end

        it 'resumes the parent on a reduced waitlist' do
          parent.waitlist.should eq(@child2 => true)
          parent.waitfor.should eq(:enacter)
        end

      end # with a parent

      context 'when the child has no parent' do

        before do
          @child = list.save Prog.new
          subject
        end

        it 'ends the child' do
          child.pc.should eq(-1)
          child.waitlist.should eq({})
          child.waitfor.should eq(:none)
        end

      end # withoutb a parent

    end
  end
end
