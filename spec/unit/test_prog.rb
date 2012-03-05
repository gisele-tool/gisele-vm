require 'spec_helper'
class Gisele::VM
  describe Prog do

    let(:h){
      { :puid     => "puid",
        :parent   => "parent",
        :pc       => 12,
        :waitlist => {:a => true},
        :progress => true,
        :input    => [ :event ] }
    }

    it 'has defaults' do
      s = Prog.new
      s.puid.should     be_nil
      s.parent.should   be_nil
      s.pc.should       eq(0)
      s.waitlist.should eq({})
      s.progress.should eq(false)
      s.input.should    eq([])
    end

    it 'understand options' do
      s = Prog.new(h)
      s.puid.should     eq("puid")
      s.parent.should   eq("parent")
      s.pc.should       eq(12)
      s.waitlist.should eq({:a => true})
      s.progress.should eq(true)
      s.input.should    eq([:event])
    end

    it 'provides a to_hash' do
      s = Prog.new(h)
      s.to_hash.should eq(h)
    end

    it 'provides value-equal duplication' do
      s = Prog.new(:puid => 12, :waitlist => {:a => true})
      s.dup.object_id.should_not eq(s.object_id)
      s.dup.should eq(s)
    end

    it 'duplicates deeply' do
      s = Prog.new(h)
      s.dup.waitlist[:b] = false
      s.waitlist.should eq({:a => true})
      s.dup.input << :blih
      s.input.should eq([:event])
    end

  end
end