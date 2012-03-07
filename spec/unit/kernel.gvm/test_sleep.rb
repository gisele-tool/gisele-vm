require 'spec_helper'
module Gisele
  class VM
    describe Kernel, "sleep macro" do

      let(:list)  { ProgList.memory                           }
      let(:vm)    { Kernel.new @parent, Bytecode.kernel, list }
      let(:parent){ list.fetch(@parent)                       }

      before do
        @parent = list.save Prog.new(:waitfor => :world)
        subject
      end

      subject do
        vm.run(:sleep, [ ])
      end

      after do
        vm.stack.should be_empty
      end

      it 'sleeps the current Prog' do
        parent.waitfor.should_not eq(:enacter)
      end

    end
  end
end
