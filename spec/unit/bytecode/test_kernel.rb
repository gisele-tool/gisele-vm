require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '.parse' do

      subject{
        Bytecode.kernel
      }

      it 'returns a Bytecode instance' do
        subject.should be_a(Bytecode)
      end

      it 'has the expected bytecode' do
        subject[:start].should_not be_nil
        subject[:resume].should_not be_nil
        subject[:run].should_not be_nil
      end

    end
  end
end
