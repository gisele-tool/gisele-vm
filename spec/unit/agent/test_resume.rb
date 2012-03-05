require 'spec_helper'
module Gisele
  class VM
    describe Agent, "resume" do

      let(:agent){ Agent.new Path.dir/'code.gvm' }

      before do
        @puid = agent.proglist.save Prog.new(:progress => false)
      end

      subject{
        agent.resume(@puid, [ :an_event ])
        agent.dump
      }

      it 'creates a fresh new Prog instance and schedules it' do
        expected = Relation(:puid => @puid, :progress => true, :input => [ :an_event ])
        subject.project([:puid, :progress, :input]).should eq(expected)
      end

    end
  end
end
