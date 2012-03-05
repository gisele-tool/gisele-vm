require 'spec_helper'
module Gisele
  class VM
    class ProgList
      describe Threadsafe, "releasing process" do
        let(:list){ Threadsafe.new(self) }

        def pick
          nil
        end

        it 'blocks a pick call until a save' do
          called = false
          t1 = Thread.new(list){|l|
            l.pick{ called = true }
          }
          t2 = Thread.new(list){|l|
            sleep(0.01) until called
            l.release
          }
          t2.join
          t1.value.should be_nil
        end

      end
    end
  end
end
