require 'spec_helper'
module Gisele
  class VM
    describe Registry, "connect" do

      let(:registry){ Registry.new }
      let(:c1){ Component.new }
      let(:c2){ Component.new }
      let(:c3){ Component.new }

      subject do
        registry.disconnect
      end

      before do
        registry.register(c1)
        registry.register(c2)
        registry.register(c3)
        registry.components.should eq([c1, c2, c3])
        registry.connect(vm)
        subject
      end

      context 'when everything goes fine' do
        it 'keeps components registered' do
          registry.components.should eq([c1, c2, c3])
        end
        it 'disconnects all components' do
          registry.components.each do |c|
            c.should_not be_connected
          end
        end
      end

      context 'when a component encounters an error' do
        before do
          def c3.disconnect
            super
            raise ArgumentError
          end
        end
        it 'silently disconnects all components' do
          registry.components.each do |c|
            c.should_not be_connected
          end
        end
      end

    end
  end
end
