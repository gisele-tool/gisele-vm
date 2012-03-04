require 'spec_helper'
module Gisele
  class VM
    describe "kernel::fork" do

      let(:vm) { VM.new 0, Bytecode.kernel }

      before do
        prog  = Prog.new(:pc => :fork)
        @puid = vm.proglist.save(prog)
      end

      subject{
        vm.run(:fork, [ :joinat, [ :fat1, :fat2 ] ])
        vm.stack.should be_empty
        vm.proglist.fetch(@puid)
      }

      it 'sets the events as waitlist' do
        subject.waitlist.should eq({1 => true, 2 => true})
      end

      it 'fork and schedules self and children correctly' do
        subject
        expected = Relation([
          {:puid => 0, :pc => :joinat, :parent => 0, :progress => false},
          {:puid => 1, :pc => :fat1,   :parent => 0, :progress => true},
          {:puid => 2, :pc => :fat2,   :parent => 0, :progress => true}
        ])
        rel = vm.proglist.to_relation.project([:puid, :pc, :parent, :progress])
        rel.should eq(expected)
      end

    end
  end
end
