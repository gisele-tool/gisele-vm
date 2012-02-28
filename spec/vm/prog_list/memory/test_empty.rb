require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'empty' do
    let(:list){ ProgList::Memory.new }

    it 'returns true on an empty list' do
      list.should be_empty
    end

    it 'returns false on a non empty list' do
      list.register(Prog.new)
      list.should_not be_empty
    end

  end
end
