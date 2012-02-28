require 'spec_helper'
class Gisele::VM
  describe ProgList, 'save' do
    let(:list){ ProgList.new }

    before do
      @uuid = list.register(Prog.new)
    end

    it 'returns the uuid' do
      list.save(list.fetch(@uuid)).should eq(@uuid)
    end

    it 'saves the prog for real' do
      list.fetch(@uuid).pc.should eq(0)

      # update it
      prog = list.fetch(@uuid)
      prog.pc = 12

      # the original have not changed
      list.fetch(@uuid).pc.should eq(0)

      # save and check
      list.save(prog)
      list.fetch(@uuid).pc.should eq(12)
    end

    it 'makes a dup when saving' do
      prog = list.fetch(@uuid)
      prog.pc = 12
      list.save(prog)
      prog.pc = 23
      list.fetch(@uuid).pc.should eq(12)
    end

    it 'raises an ArgumentError if arg is not an UUID' do
      lambda{
        list.save(self)
      }.should raise_error(ArgumentError)
    end

    it 'raises an InvalidUUIDError if arg is invalid' do
      lambda{
        list.save(Prog.new(:uuid => 12))
      }.should raise_error(InvalidUUIDError)
    end

  end
end