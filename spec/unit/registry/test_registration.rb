require 'spec_helper'
module Gisele
  class VM
    describe Registry, "registration" do

      subject{ Registry.new(vm)  }
      let(:c){ Component.new }
      let(:c_prior){ Component.new }

      it 'allows registering and unregistering components' do
        subject.register(c)
        subject.components.should be_include(c)
        c.should be_registered
        c.vm.should eq(vm)
        subject.unregister(c)
        subject.components.should_not be_include(c)
        c.should_not be_registered
      end

      it 'allows registring prior components' do
        subject.register(c)
        subject.register(c_prior, true)
        subject.components.should eq([c_prior, c])
        c.should be_registered
      end

      it 'raises an error if hot registration' do
        subject.connect
        lambda{
          subject.register(c)
        }.should raise_error(NotImplementedError)
      end

      it 'raises an error if hot unregistration' do
        subject.register(c)
        subject.connect
        lambda{
          subject.unregister(c)
        }.should raise_error(NotImplementedError)
      end

    end
  end
end
