require 'spec_helper'
module Gisele
  class VM
    class ProgList
      describe Delegate do

        class PingProgList

          def method_missing(*args, &bl)
            args
          end

        end # class PingProgList

        let(:list){ Delegate.new(PingProgList.new) }

        it 'delegates a fetch invocation' do
          list.fetch(0).should eq([:fetch, 0])
        end

        it 'delegates a save invocation' do
          prog = Prog.new
          list.save(prog).should eq([:save, prog])
        end

        it 'delegates a pick invocation' do
          list.pick(:enacter).should eq([:pick, :enacter])
        end

        it 'delegates an empty? invocation' do
          list.empty?.should eq([:empty?])
        end

        it 'delegates a to_relation invocation' do
          list.to_relation.should eq([:to_relation])
        end

      end
    end
  end
end
