require 'spec_helper'
class Gisele::VM::ProgList
  describe Threadsafe do
    include Gisele::VM::FakeComponent
    let(:list){ Threadsafe.new(self) }

    context 'when not connected' do
      it 'returns nil' do
        list.pick(:waitfor => :enacter).should be_nil
      end
    end # not connected

    context 'when connected' do
      before{ list.connect(vm)                   }
      after { list.disconnect if list.connected? }

      context 'when something is ready' do
        def pick(arg); :something; end
        it 'returns something' do
          list.pick(:waitfor => :enacter).should eq(:something)
        end
      end # something is ready

      context 'when nothing is ready' do
        def pick(arg); @saved;       end
        def save(arg); @saved = arg; end

        before do
          stopped = false
          @thread = Thread.new(list){|l|
            l.pick(:waitfor => :enacter){ stopped = true }
          }
          Thread.pass until stopped
        end

        it 'enters the lock and leaves it at save' do
          list.save(:something)
          @thread.value.should eq(:something)
        end

        it 'enters the lock and leaves it at disconnect' do
          list.disconnect
          @thread.value.should be_nil
        end
      end # nothing is ready

    end # connected

  end
end
