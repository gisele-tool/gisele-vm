require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'register' do
    let(:list){ ProgList::Memory.new }

    it 'returns a valid UUID' do
      uuid = list.register(Prog.new)
      uuid.should_not be_nil
      list.fetch(uuid).uuid.should eq(uuid)
    end

    it 'keeps the specified parent if any' do
      uuid = list.register(Prog.new(:parent => 27))
      list.fetch(uuid).parent.should eq(27)
    end

    it 'sets the parent to itself if no parent' do
      uuid = list.register(Prog.new)
      list.fetch(uuid).parent.should eq(uuid)
    end

    it 'does not keep the original registered progs' do
      prog = Prog.new(:pc => 12)
      uuid = list.register(prog)
      prog.pc = 24
      list.fetch(uuid).pc.should eq(12)
    end

    it 'raises an ArgumentError is not a Prog' do
      lambda{
        list.register(self)
      }.should raise_error(ArgumentError)
    end

  end
end