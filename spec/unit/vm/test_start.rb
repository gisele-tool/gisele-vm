require 'spec_helper'
module Gisele
  describe VM, "start" do

    subject do
      vm.start(:main, [ 12 ])
    end

    before do
      subject
    end

    it 'returns a puid' do
      list.fetch(subject).should be_a(VM::Prog)
      list.fetch(subject).pc.should eq(:main)
    end

    it 'creates a fresh new Prog instance and schedules it' do
      expected = Relation(:pc => :main, :waitfor => :enacter, :input => [ 12 ])
      list.to_relation.project([:pc, :waitfor, :input]).should eq(expected)
    end

  end
end
