require 'spec_helper'
module Gisele
  class VM
    describe Agent, "load" do

      subject do
        Agent.new(Path.dir/'code.gvm').vm
      end

      it 'loads the kernel' do
        subject.bytecode[:start].should_not be_nil
        subject.bytecode[:resume].should_not be_nil
        subject.bytecode[:run].should_not be_nil
      end

      it 'loads the code' do
        subject.bytecode[:A_start].should_not be_nil
      end

    end
  end
end
