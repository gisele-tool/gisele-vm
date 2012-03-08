require 'spec_helper'
module Gisele
  describe VM, "start" do

    before do
      @puid = vm.start(:ping, [ "world" ])
      subject
    end

    subject do
      vm.progress(@puid)
    end

    it 'executes the Prog with its input' do
      @events.should eq([ VM::Event.new(@puid, :pong, [ "world" ]) ])
    end

    it 'resets the input' do
      list.fetch(@puid).input.should eq([])
    end

  end
end
