require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Memory, "threadsafe" do
      let(:list){ ProgList::Memory.new }

      it 'returns a threadsafe instance' do
        list.threadsafe.should be_a(ProgList::Threadsafe)
      end

    end
  end
end
