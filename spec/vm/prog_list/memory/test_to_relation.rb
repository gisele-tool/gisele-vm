require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'save' do
    let(:list){ ProgList::Memory.new }

    before do
      @puids = (0..1).map{ list.register(Prog.new) }
      @puids.size.should eq(2)
    end

    it 'helps getting a relation' do
      list.to_relation.should be_a(Alf::Relation)
      list.to_relation.project([:puid]).should eq(Relation(:puid => @puids))
    end

  end
end
