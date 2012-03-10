require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "op_save" do

      before do
        @puid0 = list.save Prog.new
        @puid1 = list.save Prog.new
        @at0 = list.fetch(@puid0)
        @at1 = list.fetch(@puid1)
        runner.stack = [ [ @at0, @at1 ] ]
        runner.peek.each{|p| p.pc = 12}
      end

      subject do
        runner.op_savea
      end

      after do
        top = runner.peek
        top.each do |puid|
          list.fetch(puid).pc.should eq(12)
        end
      end

      it 'puts the saved puid back on the stack' do
        subject
        runner.stack.size.should eq(1)
        runner.peek.should be_a(Array)
      end

    end
  end
end
