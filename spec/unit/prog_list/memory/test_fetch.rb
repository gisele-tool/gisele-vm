require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'fetch' do
    let(:list){ ProgList::Memory.new }

    before do
      @puid = list.save(Prog.new)
    end

    it 'returns Progs' do
      list.fetch(@puid).should be_a(Prog)
    end

    it 'returns the correct Prog' do
      list.fetch(@puid).puid.should eq(@puid)
    end

    it 'distributes copies, not original Progs' do
      list.fetch(@puid).pc = :newpc
      list.fetch(@puid).pc.should eq(0)
    end

    it 'allows passing strings' do
      list.fetch(@puid.to_s).should be_a(Prog)
    end

    it 'raises an ArgumentError if arg is not an PUID' do
      lambda{
        list.fetch(:blih)
      }.should raise_error(InvalidPUIDError, "Invalid puid: `:blih`")
    end

    it 'raises an InvalidPUIDError if arg is invalid' do
      lambda{
        list.fetch(12)
      }.should raise_error(InvalidPUIDError, "Invalid puid: `12`")
    end

  end
end
