require 'spec_helper'
class Gisele::VM
  describe Prog do

    let(:h){
      {:uuid => "uuid", :parent => "parent", :pc => 12, :wait => [:a]}
    }

    it 'has defaults' do
      s = Prog.new
      s.uuid.should be_nil
      s.parent.should be_nil
      s.pc.should eq(0)
      s.wait.should eq([])
    end

    it 'understand options' do
      s = Prog.new(:uuid => "uuid", :parent => "parent", :pc => 12, :wait => [:a])
      s.uuid.should eq("uuid")
      s.parent.should eq("parent")
      s.pc.should eq(12)
      s.wait.should eq([:a])
    end

    it 'provides a to_hash' do
      s = Prog.new(h)
      s.to_hash.should eq(h)
    end

    it 'provides value-equal duplication' do
      s = Prog.new(:uuid => 12, :wait => [:a])
      s.dup.object_id.should_not eq(s.object_id)
      s.dup.should eq(s)
    end

    it 'duplicates deeply' do
      s = Prog.new(:wait => [:a])
      s.dup.wait << :b
      s.wait.should eq([:a])
    end

  end
end