require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'save' do

    context 'when arg is an existing Prog' do
      let(:puid){ 0 }
      let(:list){ ProgList.memory([ Prog.new(:puid => puid) ]) }

      it 'returns the puid' do
        list.save(list.fetch(puid)).should eq(puid)
      end

      it 'saves the prog for real' do
        list.fetch(puid).pc.should eq(:main)

        # update it
        prog = list.fetch(puid)
        prog.pc = 12

        # the original have not changed
        list.fetch(puid).pc.should eq(:main)

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

    end # PUID

    context 'when arg is a fresh new Prog' do
      let(:puid){ nil }
      let(:list){ ProgList.memory([ ]) }

      it 'sets a fresh new puid' do
        puid = list.save(Prog.new)
        puid.should_not be_nil
        list.fetch(puid).puid.should eq(puid)
        list.fetch(puid).parent.should eq(puid)
        list.fetch(puid).root.should eq(puid)
      end

      it 'accepts a valid parent' do
        parent = list.save(Prog.new)
        child  = list.save(Prog.new(:parent => parent))
        list.fetch(child).parent.should eq(parent)
      end
    end

    context 'when arg is an array of Progs' do
      let(:list){ ProgList.memory([ ]) }

      subject do
        list.save([ Prog.new, Prog.new ])
      end

      it 'returns a list of puids' do
        subject.should be_a(Array)
      end

      it 'returns valid puids' do
        subject.each{|p| list.fetch(p).should be_a(Prog)}
      end

    end

    it 'raises an ArgumentError if arg is not recognized' do
      lambda{
        ProgList.memory.save(self)
      }.should raise_error(ArgumentError)
    end

    it 'raises an InvalidPUIDError if arg is invalid' do
      lambda{
        ProgList.memory.save(Prog.new(:puid => 12))
      }.should raise_error(InvalidPUIDError)
    end

  end
end
