require 'spec_helper'
module Gisele
  describe VM, "the event facade" do

    it 'delegates event calls to it' do
      vm.event(an_event)
      observed_events.should eq([an_event])
    end

  end
end
