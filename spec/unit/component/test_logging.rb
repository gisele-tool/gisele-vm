require 'spec_helper'
module Gisele
  class VM
    describe Component, "logging delegation" do
      include Component

      context 'without vm' do

        it 'uses a NullObject to avoid failing' do
          vm.should be_a(NullObject)
        end

        it 'delegates logger methods to it' do
          lambda{
            info("message")
          }.should_not raise_error
        end

      end # without vm

      context 'with a vm' do

        def vm
          Struct.new(:info).new("blah")
        end

        it 'delegates logger methods to it' do
          info.should eq("blah")
        end

      end # with a vm

    end
  end
end
