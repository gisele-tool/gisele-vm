require 'spec_helper'
module Gisele
  describe VM, "initialize" do

    after do
      vm.should_not be_running
      vm.status.should eq(:stopped)
      vm.components[0].should be_a(VM::Kernel)
      vm.components[1].should be_a(VM::ProgList)
      vm.components[2].should be_a(VM::EventManager)
    end

    context 'without block' do
      let(:vm){ VM.new }

      it 'installs a threadsafe Memory prog list' do
        vm.proglist.should be_a(VM::ProgList::Threadsafe)
        vm.proglist.delegate.should be_a(VM::ProgList::Memory)
      end

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
      let(:em){ VM::EventManager.new }
      let(:vm){
        VM.new([:gvm, [:block, :hello, [:nop]]]) do |vm|
          vm.proglist      = VM::ProgList.memory
          vm.logger        = nil
          vm.event_manager = em
        end
      }

      it 'merges the kernel bytecode and the provided one' do
        vm.bytecode[:hello].should_not be_nil
        vm.bytecode[:start].should_not be_nil
      end

      it 'installs the provided proglist' do
        vm.proglist.should be_a(VM::ProgList::Memory)
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
