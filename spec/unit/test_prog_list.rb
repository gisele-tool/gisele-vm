require 'spec_helper'
module Gisele
  class VM
    describe ProgList do

      context 'with a ruby memory storage' do
        subject do
          ProgList.new ProgList::Memory.new
        end
        it_should_behave_like "a component"
      end

      context 'with a sqldb storage' do
        subject do
          ProgList.new ProgList.storage("memory")
        end
        it_should_behave_like "a component"
      end

    end
  end
end
