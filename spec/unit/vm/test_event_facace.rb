require 'spec_helper'
module Gisele
  describe VM, "the event facade" do

    let(:vm){
      VM.new do |vm|
        vm.event_manager = lambda{|evt|
          @event = evt
        }
      end
    }

    it 'delegates event calls to it' do
      vm.event(an_event)
      @event.should eq(an_event)
    end

  end
end
