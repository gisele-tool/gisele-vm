require 'spec_helper'
module Gisele
  describe VM, "start" do

    subject do
      vm.resume(@puid, [ :an_event ])
    end

    before do
      @puid = list.save VM::Prog.new(:pc => :hello, :waitfor => :world)
      subject
    end

    it 'creates a fresh new Prog instance and schedules it' do
      expected = Relation(:puid => @puid, :waitfor => :enacter, :input => [ :an_event ])
      list.to_relation.project([:puid, :waitfor, :input]).should eq(expected)
    end

  end
end
