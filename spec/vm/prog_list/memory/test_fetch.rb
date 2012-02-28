require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'fetch' do
    let(:list){ ProgList::Memory.new }

    before do
      @uuid = list.register(Prog.new)
    end

    it 'returns Progs' do
      list.fetch(@uuid).should be_a(Prog)
    end

    it 'returns the correct Prog' do
      list.fetch(@uuid).uuid.should eq(@uuid)
    end

    it 'distributes copies, not original Progs' do
      list.fetch(@uuid).pc = :newpc
      list.fetch(@uuid).pc.should eq(0)
    end

    it 'allows passing strings' do
      list.fetch(@uuid.to_s).should be_a(Prog)
    end

    it 'raises an ArgumentError if arg is not an UUID' do
      lambda{
        list.fetch(self)
      }.should raise_error(ArgumentError)
    end

    it 'raises an InvalidUUIDError if arg is invalid' do
      lambda{
        list.fetch(12)
      }.should raise_error(InvalidUUIDError)
    end

  end
end
