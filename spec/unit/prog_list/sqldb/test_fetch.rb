require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Sqldb, 'fetch' do
      let(:db){ ProgList::Sqldb sqlite_empty }

      before do
        db.connect(vm)
        @puid = db.save(Prog.new)
      end

    end
  end
end
