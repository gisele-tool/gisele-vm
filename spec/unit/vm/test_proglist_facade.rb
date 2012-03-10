require 'spec_helper'
module Gisele
  describe VM, "the proglist facade" do

    let(:vm){
      VM.new do |vm|
        vm.proglist = VM::ProgList.memory([ VM::Prog.new(:waitfor => :enacter, :pc => 17) ])
      end
    }

    it 'delegates fetch/save calls to it' do
      puid = vm.save(VM::Prog.new(:pc => :ping))
      vm.fetch(puid).pc.should eq(:ping)
    end

    it 'delegates pick calls to it' do
      vm.pick(:waitfor => :enacter).pc.should eq(17)
      vm.pick(:waitfor => :world).should be_nil
    end

  end
end
