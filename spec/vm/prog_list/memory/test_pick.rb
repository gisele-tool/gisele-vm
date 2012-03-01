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

      it 'returns nil' do
        list.pick.should be_nil
      end

    end

  end
end
