require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "constant" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :constant)
      end

      it 'parses single constants correctly' do
        parse("Integer").value.should eq(Integer)
      end

      it 'parses qualified constants correctly' do
        parse("Gisele::VM").value.should eq(Gisele::VM)
      end

    end
  end
end
