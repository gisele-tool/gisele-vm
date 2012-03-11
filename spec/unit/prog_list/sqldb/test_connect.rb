require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Sqldb, 'connect', :sqlite => true do

      subject do
        ProgList::Sqldb.new(options).connect(vm)
      end

      context 'when the database is unreachable' do
        let(:options){ {:uri => "postgres://localhost:145/database"} }
        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(Sequel::Error)
        end
      end

      context 'when the database is creatable' do
        let(:options){ sqlite_none }
        it 'returns itself' do
          subject.should be_a(ProgList::Sqldb)
        end
        it 'sets the database under sequel_db' do
          subject.sequel_db.should be_a(Sequel::Database)
        end
        it 'installs the schema' do
          table_name = subject.send(:table_name)
          subject.sequel_db.table_exists?(table_name).should be_true
        end
      end

      context 'when the database is already created' do
        let(:options){ sqlite_empty }
        it 'returns itself' do
          subject.should be_a(ProgList::Sqldb)
        end
        it 'sets the database under sequel_db' do
          subject.sequel_db.should be_a(Sequel::Database)
        end
        it 'installs the schema' do
          table_name = subject.send(:table_name)
          subject.sequel_db.table_exists?(table_name).should be_true
        end
      end

    end
  end
end
