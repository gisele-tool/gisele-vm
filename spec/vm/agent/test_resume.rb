require 'spec_helper'
module Gisele
  class VM
    describe Agent, "resume" do

      let(:agent){ Agent.new Path.dir/'code.gvm' }

      before do
        @puid = agent.proglist.save Prog.new(:progress => false)
      end

      subject{ 
        agent.resume(@puid)
        agent.dump
      }

      it 'creates a fresh new Prog instance and schedules it' do
        expected = Relation(:puid => @puid, :progress => true)
        subject.project([:puid, :progress]).should eq(expected)
      end

    end
  end
end