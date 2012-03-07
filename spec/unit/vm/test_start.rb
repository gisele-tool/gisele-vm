require 'spec_helper'
module Gisele
  describe VM, "start" do

    subject do
      vm.start(:main)
    end

    before do
      subject
    end

    it 'creates a fresh new Prog instance and schedules it' do
      expected = Relation(:pc => :main, :waitfor => :enacter)
      list.to_relation.project([:pc, :waitfor]).should eq(expected)
    end

  end
end
