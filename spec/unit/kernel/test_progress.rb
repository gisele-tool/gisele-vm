require 'spec_helper'
module Gisele
  describe VM, "progress" do

    subject do
      kernel.progress(arg)
    end

    before do
      @puid = kernel.start(:ping, [ "world" ])
    end

    context 'with a puid' do
      let(:arg){ @puid }
      it 'executes the Prog with its input' do
        subject
        prog           = list.fetch(@puid)
        expected_event = VM::Event.new(prog, :pong, [ "world" ])
        @events.should eq([ expected_event ])
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
        kernel.progress(17)
      }.should raise_error(VM::InvalidPUIDError, "Invalid puid: `17`")
    end

    it 'detects progs that do not wait for the enacter' do
      list.save(VM::Prog.new :puid => @puid, :waitfor => :world)
      lambda{
        kernel.progress(@puid)
      }.should raise_error(VM::InvalidStateError, "Prog `#{@puid}` does not wait for the enacter")
    end

  end
end
