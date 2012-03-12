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

        it 'allows getting the delegate object' do
          list.delegate.should be_a(PingProgList)
        end

        it 'delegates a fetch invocation' do
          list.fetch(0).should eq([:fetch, 0])
        end

        it 'delegates a save invocation' do
          prog = Prog.new
          list.save(prog).should eq([:save, prog])
        end

        it 'delegates a pick invocation' do
          r = {:waitfor => :enacter}
          list.pick(r).should eq([:pick, r])
        end

        it 'delegates a to_relation invocation' do
          list.to_relation.should eq([:to_relation])
        end

        it 'delegates connect(vm) and disconnect calls' do
          list.connect(vm).should eq([:connect, vm])
          list.disconnect.should eq([:disconnect])
        end

      end
    end
  end
end
