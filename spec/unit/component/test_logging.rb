require 'spec_helper'
module Gisele
  class VM
    describe Component, "logging delegation" do

      let(:component){ Component.new }

      context 'without vm' do

        it 'uses a NullObject to avoid failing' do
          component.vm.should be_a(NullObject)
        end

        it 'delegates logger methods to it' do
          lambda{
            component.info("message")
          }.should_not raise_error
        end

      end # without vm

      context 'with a vm' do

        before do
          component.registered Struct.new(:info).new("blah")
        end

        it 'delegates logger methods to it' do
          component.info.should eq("blah")
        end

      end # with a vm

    end
  end
end
