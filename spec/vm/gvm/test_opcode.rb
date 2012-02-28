require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "opcode" do

      def parse(src)
        Gvm.parse(src, :root => :opcode)
      end

      it 'parses typical opcodes' do
        parse("dump").value.should eq(:dump)
        parse("pop").value.should eq(:pop)
      end

      it 'does not allow numerics' do
        lambda{
          parse('pop0')
        }.should raise_error(Citrus::ParseError)
      end

    end
  end
end