require 'spec_helper'
module Gisele
  describe VM, "progress" do

    before do
      @puid = vm.start(:ping, [ "world" ])
      subject
    end

    subject do
      vm.progress(@puid)
    end

    it 'executes the Prog with its input' do
      prog = list.fetch(@puid)
      @events.should eq([ VM::Event.new(prog, :pong, [ "world" ]) ])
    end

    it 'resets the input' do
      list.fetch(@puid).input.should eq([])
    end

    it 'detects invalid puids' do
      lambda{
        vm.progress(17)
      }.should raise_error(VM::InvalidPUIDError, "Invalid puid: `17`")
    end

    it 'detects progs that do not wait for the enacter' do
      list.save(VM::Prog.new :puid => @puid, :waitfor => :world)
      lambda{
        vm.progress(@puid)
      }.should raise_error(VM::InvalidStateError, "Prog `#{@puid}` does not wait for enactement progress")
    end

  end
end
