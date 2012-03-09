require 'spec_helper'
module Gisele
  describe VM, "progress" do

    subject do
      vm.progress(arg)
    end

    before do
      @puid = vm.start(:ping, [ "world" ])
    end

    context 'with a puid' do
      let(:arg){ @puid }
      it 'executes the Prog with its input' do
        subject
        @events.should eq([ VM::Event.new(list.fetch(@puid), :pong, [ "world" ]) ])
        list.fetch(@puid).input.should eq([])
      end
    end

    context 'with a prog' do
      let(:arg){ list.fetch(@puid) }
      it 'executes the Prog with its input' do
        subject
        @events.should eq([ VM::Event.new(arg, :pong, [ "world" ]) ])
        list.fetch(@puid).input.should eq([])
      end
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
