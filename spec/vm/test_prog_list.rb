require 'spec_helper'
class Gisele::VM
  describe ProgList do

    let(:list){ ProgList.new }

    it 'allows registering Progs' do
      prog = Prog.new
      uuid = list.register(prog)
      uuid.should_not be_nil
      list.fetch(uuid).uuid.should eq(uuid)
    end

    it 'does not keep the original registered progs' do
      prog = Prog.new(:pc => 12)
      uuid = list.register(prog)
      prog.pc = 24
      list.fetch(uuid).pc.should eq(12)
    end

    it 'allows fetching registered progs' do
      uuid = list.register(Prog.new)
      list.fetch(uuid).should be_a(Prog)
    end

    it 'distributes copies, not original Progs' do
      uuid = list.register(Prog.new)
      list.fetch(uuid).pc = :newpc
      list.fetch(uuid).pc.should eq(0)
    end

    it 'allows saving progs' do
      prog = list.fetch(list.register(Prog.new))
      prog.pc = 12
      list.fetch(0).pc.should eq(0)
      list.save(prog)
      list.fetch(0).pc.should eq(12)
    end

    it 'makes a dup when saving' do
      prog = list.fetch(list.register(Prog.new))
      prog.pc = 12
      list.save(prog)
      prog.pc = 23
      list.fetch(0).pc.should eq(12)
    end

  end
end