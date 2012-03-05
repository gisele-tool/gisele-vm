require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '.parse' do

      let(:file){ Path.dir/'bytecode.gvm' }

      subject{
        Bytecode.parse(file)
      }

      it 'returns a Bytecode instance' do
        subject.should be_a(Bytecode)
      end

      it 'has the expected bytecode' do
        subject[:s0].should eq([ [:push, 12] ])
      end

    end
  end
end
