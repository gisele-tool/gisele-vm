require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "array" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :array)
      end

      it 'parses empty arrays correctly' do
        parse("[ ]").value.should eq([])
      end

      it 'parses singletons correcttly' do
        parse("[0]").value.should eq([0])
      end

      it 'parses arrays correcttly' do
        parse("[0, 'blah', :symb]").value.should eq([0, 'blah', :symb])
      end

    end
  end
end
