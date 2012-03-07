require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "boolean" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :boolean)
      end

      it 'parses true' do
        parse("true").value.should eq(true)
      end

      it 'parses false' do
        parse("false").value.should eq(false)
      end

    end
  end
end
