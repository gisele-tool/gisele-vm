require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'pick' do
    let(:list){ ProgList::Memory.new }

    context 'when a matching Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:waitfor => :world))
        @puid1 = list.save(Prog.new(:waitfor => :enacter))
      end

      it 'returns a Prog' do
        list.pick(:waitfor => :enacter).should be_a(Prog)
      end

      it 'returns a scheduled Prog' do
        list.pick(:waitfor => :enacter).waitfor.should eq(:enacter)
      end

    end

    context 'when no matching Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:waitfor => :world))
        @puid1 = list.save(Prog.new(:waitfor => :world))
      end

      it 'calls the block and returns nil' do
        called = false
        list.pick(:waitfor => :enacter){ called = true }.should be_nil
        called.should be_true
      end

    end

  end
end
