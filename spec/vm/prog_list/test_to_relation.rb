require 'spec_helper'
class Gisele::VM
  describe ProgList, 'save' do
    let(:list){ ProgList.new }

    before do
      @uuids = (0..1).map{ list.register(Prog.new) }
      @uuids.size.should eq(2)
    end

    it 'helps getting a relation' do
      list.to_relation.should be_a(Alf::Relation)
      list.to_relation.project([:uuid]).should eq(Relation(:uuid => @uuids))
    end

  end
end