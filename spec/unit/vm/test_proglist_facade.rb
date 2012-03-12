require 'spec_helper'
module Gisele
  describe VM, "the proglist facade" do

    let(:vm){
      VM.new do |vm|
        vm.proglist = VM::ProgList.memory
      end
    }

    it 'delegates fetch/save calls to it' do
      puid = vm.save(VM::Prog.new(:pc => :ping))
      vm.fetch(puid).pc.should eq(:ping)
    end

  end
end
