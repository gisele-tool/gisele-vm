require 'spec_helper'
module Gisele
  class VM
    class ProgList
      describe Threadsafe do

        let(:list){ Threadsafe.new(self) }

        def save(prog)
          @prog = prog
        end

        def pick(waitfor)
          @prog
        end

        it 'blocks a pick call until a save' do
          called = false
          t1 = Thread.new(list){|l|
            l.pick(:enacter){ called = true }
          }
          t2 = Thread.new(list){|l|
            sleep(0.01) until called
            l.save("Saved!")
          }
          t2.join
          t1.value.should eq("Saved!")
        end

      end
    end
  end
end
