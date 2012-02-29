require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'register' do
    let(:list){ ProgList::Memory.new }

    it 'returns a valid PUID' do
      puid = list.register(Prog.new)
      puid.should_not be_nil
      list.fetch(puid).puid.should eq(puid)
    end

    it 'keeps the specified parent if any' do
      puid = list.register(Prog.new(:parent => 27))
      list.fetch(puid).parent.should eq(27)
    end

    it 'sets the parent to itself if no parent' do
      puid = list.register(Prog.new)
      list.fetch(puid).parent.should eq(puid)
    end

    it 'does not keep the original registered progs' do
      prog = Prog.new(:pc => 12)
      puid = list.register(prog)
      prog.pc = 24
      list.fetch(puid).pc.should eq(12)
    end

    it 'raises an ArgumentError is not a Prog' do
      lambda{
        list.register(self)
      }.should raise_error(ArgumentError)
    end

  end
end
