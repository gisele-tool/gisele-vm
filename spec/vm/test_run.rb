require 'spec_helper'
module Gisele
  class VM
    describe "run" do

      let(:vm){ VM.new 0, bytecode }

      before do
        vm.proglist.save Prog.new
      end

      context 'when the program counters points to no instruction' do
        let(:bytecode){ [ [] ] }

        it 'does nothing apparent at first glance' do
          vm.run
          vm.stack.should be_empty
          vm.opcodes.should be_empty
        end
      end

    end
  end
end
