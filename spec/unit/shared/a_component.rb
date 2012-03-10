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

    end
  end
end
