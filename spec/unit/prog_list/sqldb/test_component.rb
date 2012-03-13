require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Sqldb, :sqlite => true do
      subject do
        ProgList::Sqldb.new sqlite_memory
      end
      it_should_behave_like "a component"
    end
  end
end
