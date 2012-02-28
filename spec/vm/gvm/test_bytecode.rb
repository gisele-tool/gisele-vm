module Gisele
  class VM
    describe Gvm, "bytecode" do

      it 'returns a Hash' do
        bc = Gvm.bytecode(<<-GVM.gsub(/^\s*/, ''))
          0: push 1
             save
          1: push 2
             save
        GVM
        bc.should eq(0 => [ [:push, 1], [:save] ],
                     1 => [ [:push, 2], [:save] ])
      end

    end
  end
end
