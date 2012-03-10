require 'spec_helper'
module Gisele
  class VM
    describe Registry, "registration" do

      subject{ Registry.new  }
      let(:c){ Component.new }

      it 'allows registering and unregistering components' do
        subject.register(c)
        subject.components.should be_include(c)
        subject.unregister(c)
        subject.components.should_not be_include(c)
      end

      it 'raises an error if hot registration' do
        subject.connect(self)
        lambda{
          subject.register(c)
        }.should raise_error(NotImplementedError)
      end

      it 'raises an error if hot unregistration' do
        subject.register(c)
        subject.connect(self)
        lambda{
          subject.unregister(c)
        }.should raise_error(NotImplementedError)
      end

    end
  end
end
