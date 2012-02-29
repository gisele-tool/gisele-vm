require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'save' do
    let(:puid){
      0
    }
    let(:list){
      ProgList::Memory.new([ Prog.new(:puid => puid) ])
    }


    it 'returns the puid' do
      list.save(list.fetch(puid)).should eq(puid)
    end

    it 'saves the prog for real' do
      list.fetch(puid).pc.should eq(0)

      # update it
      prog = list.fetch(puid)
      prog.pc = 12

      # the original have not changed
      list.fetch(puid).pc.should eq(0)

      # save and check
      list.save(prog)
      list.fetch(puid).pc.should eq(12)
    end

    it 'makes a dup when saving' do
      prog = list.fetch(puid)
      prog.pc = 12
      list.save(prog)
      prog.pc = 23
      list.fetch(puid).pc.should eq(12)
    end

    it 'sets a fresh new puid if not already one' do
      npuid = list.save(Prog.new(:parent => puid))
      npuid.should_not be_nil
      list.fetch(npuid).parent.should eq(puid)
    end

    it 'raises an ArgumentError if arg is not an PUID' do
      lambda{
        list.save(self)
      }.should raise_error(ArgumentError)
    end

    it 'raises an InvalidPUIDError if arg is invalid' do
      lambda{
        list.save(Prog.new(:puid => 12))
      }.should raise_error(InvalidPUIDError)
    end

  end
end
