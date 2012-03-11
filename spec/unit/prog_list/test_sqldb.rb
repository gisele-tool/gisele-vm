module Gisele
  class VM
    describe ProgList::Sqldb, :sqlite => true do
      subject do
        @proglist ||= begin
          ProgList.sqldb(sqlite_empty)
        end
      end
      it_should_behave_like "a ProgList"
    end
  end
end
