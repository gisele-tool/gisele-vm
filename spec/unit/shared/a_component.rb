module Gisele
  class VM
    shared_examples_for "a component" do

      it 'allows vm connection and deconnection' do
        the_vm = vm
        subject.connect(the_vm)
        subject.vm.should eq(the_vm)
        subject.disconnect
        subject.vm.should be_a(NullObject)
      end

      it 'has a global lock on the object' do
        subject.lock.should be_a(Mutex)
      end

      it 'raises an InvalidStateError when connect is badly used' do
        subject.connect(self)
        lambda{
          subject.connect(self)
        }.should raise_error(InvalidStateError, "Already connected")
      end

      it 'raises an InvalidStateError when disconnect is badly used' do
        lambda{
          subject.disconnect
        }.should raise_error(InvalidStateError, "Not connected")
      end

    end
  end
end
