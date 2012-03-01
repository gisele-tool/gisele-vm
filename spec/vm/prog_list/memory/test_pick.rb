require 'spec_helper'
class Gisele::VM
  describe ProgList::Memory, 'pick' do
    let(:list){ ProgList::Memory.new }

    context 'when a scheduled Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:progress => true))
        @puid1 = list.save(Prog.new(:progress => false))
      end

      it 'returns a Prog' do
        list.pick.should be_a(Prog)
      end

      it 'returns a scheduled Prog' do
        list.pick.progress.should be_true
      end

    end

    context 'when no scheduled Prog exists' do

      before do
        @puid0 = list.save(Prog.new(:progress => false))
        @puid1 = list.save(Prog.new(:progress => false))
      end

      it 'calls the block and returns nil' do
        called = false
        list.pick{ called = true }.should be_nil
        called.should be_true
      end

    end

  end
end
