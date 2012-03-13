module Gisele
  class VM
    shared_examples_for "a component" do

      it 'allows vm registration and de-registration' do
        the_vm = vm
        subject.registered(the_vm)
        subject.should be_registered
        subject.vm.should eq(the_vm)
        subject.unregistered
        subject.should_not be_registered
        subject.vm.should be_a(NullObject)
      end

      it 'allows vm connection and deconnection' do
        the_vm = vm
        subject.registered(the_vm)
        subject.connect
        subject.should be_connected
        subject.disconnect
        subject.should_not be_connected
      end

      it 'has a global lock on the object' do
        subject.lock.should be_a(Mutex)
      end

      it 'raises an InvalidStateError when connect used unregistered' do
        unless subject.registered? # the registry is always connected
          lambda{
            subject.connect
          }.should raise_error(InvalidStateError, "Not registered")
        end
      end

      it 'raises an InvalidStateError when connect is badly used' do
        subject.registered(self)
        subject.connect
        lambda{
          subject.connect
        }.should raise_error(InvalidStateError, "Already connected")
      end

      it 'raises an InvalidStateError when disconnect is badly used' do
        subject.registered(self)
        lambda{
          subject.disconnect
        }.should raise_error(InvalidStateError, "Not connected")
      end

    end
  end
end
