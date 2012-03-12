require 'spec_helper'
module Gisele
  class VM
    describe ProgList, 'engine' do
      subject{ ProgList.engine(arg) }

      before do
        subject.should be_a(ProgList::Threadsafe)
        subject.delegate.should be_a(ProgList::Sqldb)
      end

      context 'without arg' do
        let(:arg){ nil }
        it 'uses an in-memory engine' do
          subject.options[:uri].should match(/memory/)
        end
      end

      context "with 'memory'" do
        let(:arg){ "memory" }
        it 'uses an in-memory engine' do
          subject.options[:uri].should match(/sqlite:memory/)
        end
      end

      context "with a specified uri" do
        let(:arg){ "sqlite://ping.db" }
        it 'uses an in-memory engine' do
          subject.options[:uri].should eq("sqlite://ping.db")
        end
      end

      context "when options include an uri" do
        let(:arg){ {:uri => "sqlite://ping.db"} }
        it 'uses an in-memory engine' do
          subject.options[:uri].should eq("sqlite://ping.db")
        end
      end

      context "with options but no uri" do
        let(:arg){ {:ping => "pong"} }
        it 'uses an in-memory engine' do
          subject.options[:uri].should match(/sqlite:memory/)
        end
        it 'installs options' do
          subject.options[:ping].should eq("pong")
        end
      end

    end
  end
end
