require 'spec_helper'
module Gisele
  class VM
    describe Agent, "start" do

      let(:agent){ Agent.new Path.dir/'code.gvm' }

      subject{
        agent.start(:A_start)
        agent.dump
      }

      it 'creates a fresh new Prog instance and schedules it' do
        expected = Relation(:pc => :A_start, :progress => true)
        subject.project([:pc, :progress]).should eq(expected)
      end

    end
  end
end
