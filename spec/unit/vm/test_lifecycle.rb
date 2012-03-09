require 'spec_helper'
module Gisele
  class VM
    describe Lifecycle do

      class PseudoVM
        include Lifecycle

        def initialize(components)
          @components = components
          init_lifecycle
        end

        def info(msg)
        end

        def components
          @components
        end

      end
      let(:vm){ PseudoVM.new(components) }

      before do
        vm.should_not be_running
      end

      after do
        vm.should_not be_running
        components.each{|c| c.should_not be_connected }
      end

      let(:components){ [ ] }

      it 'is robust to bad stop requests' do
        lambda{
          vm.stop
        }.should raise_error(InvalidStateError, "VM not running")
      end

      context 'when everything goes fine' do

        let(:components) do
          (1..2).map{|x| Object.new.extend(VM::Component) }
        end

        before do
          @thread = vm.run!
          @thread.should be_a(Thread)
          vm.should be_running
        end

        after do
          vm.stop
          @thread.join
        end

        it 'connects components' do
          components.each{|c| c.should be_connected }
        end

        it 'run is robust to misused' do
          lambda{
            vm.run
          }.should raise_error(InvalidStateError, "VM already running")
        end

        it 'run! is robust to misused' do
          lambda{
            vm.run!
          }.should raise_error(InvalidStateError, "VM already running")
        end

      end # everything goes fine

      context 'when a component fails to start' do

        let(:components) do
          (1..2).map{|x|
            c = Object.new.extend(VM::Component)
            def c.connect(vm)
              raise ArgumentError, "blah"
            end if x == 2
            c
          }
        end

        it 'reraises the component exception' do
          lambda{
            vm.run!
          }.should raise_error(ArgumentError, "blah")
        end

      end # fail at start

    end
  end
end