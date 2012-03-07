require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'pick' do
    let(:list){ ProgList::Memory.new }

    context 'when a scheduled Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:waitfor => :world))
        @puid1 = list.save(Prog.new(:waitfor => :enacter))
      end

      it 'returns a Prog' do
        list.pick(:enacter).should be_a(Prog)
      end

      it 'returns a scheduled Prog' do
        list.pick(:enacter).waitfor.should eq(:enacter)
      end

    end

    context 'when no scheduled Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:waitfor => :world))
        @puid1 = list.save(Prog.new(:waitfor => :world))
      end

      it 'calls the block and returns nil' do
        called = false
        list.pick(:enacter){ called = true }.should be_nil
        called.should be_true
      end

    end

  end
end
