require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "symbol" do

      def parse(src)
        Gvm.parse(src, :root => :symbol)
      end

      it 'parses alphabetic symbols' do
        parse(":abc").value.should eq(:abc)
      end

      it 'parses alphanums' do
        parse(":ab0c").value.should eq(:ab0c)
      end

      it 'allows capitals' do
        parse(":AB0C").value.should eq(:AB0C)
      end

      it 'requires a letter as first char' do
        lambda{
          parse('0ab')
        }.should raise_error(Citrus::ParseError)
      end

    end
  end
end
