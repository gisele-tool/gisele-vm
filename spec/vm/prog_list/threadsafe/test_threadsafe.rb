require 'spec_helper'
module Gisele
  class VM
    class ProgList
      describe Threadsafe, "threadsafe" do
        let(:list){ Threadsafe.new(ProgList.memory) }

        it 'returns itself' do
          list.threadsafe.should eq(list)
        end

      end
    end
  end
end
