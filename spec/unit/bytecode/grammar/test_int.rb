require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "int" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :int)
      end

      it 'parses positive integers correctly' do
        parse("101").value.should eq(101)
      end

      it 'parses negative integers correctly' do
        parse("-101").value.should eq(-101)
      end

      it 'parses 0' do
        parse("0").value.should eq(0)
      end

    end
  end
end
