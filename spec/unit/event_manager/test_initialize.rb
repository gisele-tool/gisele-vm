require 'spec_helper'
module Gisele
  class VM
    describe EventManager, "initialize" do

      context 'with a block' do

        subject do
          EventManager.new do |evt|
            @event = evt
          end
        end

        it 'uses the block when an event occurs' do
          subject.event(an_event)
          @event.should eq(an_event)
        end

      end # with a block

    end
  end
end
