require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Sqldb, :sqlite => true do
      subject do
        @proglist ||= begin
          ProgList::Sqldb.new(sqlite_memory)
        end
      end
      it_should_behave_like "a Storage"
    end
  end
end
