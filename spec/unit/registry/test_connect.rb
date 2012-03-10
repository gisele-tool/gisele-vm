require 'spec_helper'
module Gisele
  class VM
    describe Registry, "connect" do

      let(:registry){ Registry.new }
      let(:c1){ Component.new }
      let(:c2){ Component.new }
      let(:c3){ Component.new }

      subject do
        registry.connect(vm)
      end

      before do
        registry.register(c1)
        registry.register(c2)
        registry.register(c3)
        registry.components.should eq([c1, c2, c3])
      end

      context "when everything goes right" do
        it 'connects all components' do
          subject
          registry.components.each do |c|
            c.should be_connected
            c.vm.should eq(vm)
          end
        end
      end

      context "when a component fails to load" do
        before do
          def c2.connect(vm)
            raise ArgumentError, "blah"
          end
        end
        it 'raise the original error' do
          lambda{
            subject
          }.should raise_error(ArgumentError, "blah")
        end
        it 'disconnects connected components' do
          subject rescue nil
          registry.components.each do |c|
            c.should_not be_connected
          end
        end
      end

    end
  end
end
