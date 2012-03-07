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
      event = VM::Event.new(17, :hello, ["World"])
      vm.event(event)
      @event.should eq(event)
    end

  end
end
