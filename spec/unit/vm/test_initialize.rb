require 'spec_helper'
module Gisele
  describe VM, "initialize" do

    after do
      vm.should_not be_running
      vm.status.should eq(:stopped)
      vm.components[0].should be_a(VM::ProgList)
      vm.components[1].should be_a(VM::EventManager)
      vm.components[-1].should be_a(VM::Kernel)
    end

    context 'without block' do
      let(:vm){ VM.new }

      it 'uses the kernel bytecode' do
        vm.bytecode[:start].should_not be_nil
      end

      it 'installs a default logger' do
        vm.logger.should be_a(Logger)
      end

      it 'installs a default event manager' do
        vm.event_manager.should be_a(VM::EventManager)
      end
    end

    context 'with a block' do
      let(:em)  { VM::EventManager.new }
      let(:list){ VM::ProgList.new VM::ProgList.storage("memory") }
      let(:vm){
        VM.new([:gvm, [:block, :hello, [:nop]]]) do |vm|
          vm.proglist      = list
          vm.logger        = nil
          vm.event_manager = em
        end
      }

      it 'merges the kernel bytecode and the provided one' do
        vm.bytecode[:hello].should_not be_nil
        vm.bytecode[:start].should_not be_nil
      end

      it 'installs the provided proglist' do
        vm.proglist.should eq(list)
      end

      it 'installs the provided logger' do
        vm.logger.should be_nil
      end

      it 'installs the provided event manager' do
        vm.event_manager.should eq(em)
      end
    end

  end
end
