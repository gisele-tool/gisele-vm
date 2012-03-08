require 'spec_helper'
module Gisele
  describe VM, "start" do

    subject do
      vm.start(:ping, [ 12 ])
    end

    before do
      subject
    end

    it 'returns a puid' do
      list.fetch(subject).should be_a(VM::Prog)
      list.fetch(subject).pc.should eq(:ping)
    end

    it 'creates a fresh new Prog instance and schedules it' do
      expected = Relation(:pc => :ping, :waitfor => :enacter, :input => [ 12 ])
      list.to_relation.project([:pc, :waitfor, :input]).should eq(expected)
    end

    it 'detects invalid labels' do
      lambda{
        vm.start(:nosuchone, [])
      }.should raise_error(VM::InvalidLabelError, "Unknown label: `:nosuchone`")
    end

    it 'detects invalid inputs' do
      lambda{
        vm.start(:ping, 12)
      }.should raise_error(VM::InvalidInputError, "Invalid VM input: `12`")
    end

  end
end
