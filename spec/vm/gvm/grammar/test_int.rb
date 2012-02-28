require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "int" do

      def parse(src)
        Gvm.parse(src, :root => :int)
      end

      it 'parses integers correctly' do
        parse("101").value.should eq(101)
      end

      it 'parses 0' do
        parse("0").value.should eq(0)
      end

    end
  end
end