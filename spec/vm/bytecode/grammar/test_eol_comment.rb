require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "eol_comment" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :eol_comment)
      end

      it 'parses a comment, including the \n' do
        parse("# hello\n").should eq("# hello\n")
      end

      it 'parses a comment, if no \n but eof' do
        parse("# hello").should eq("# hello")
      end

      it 'parses an empty comment' do
        parse("#\n").should eq("#\n")
      end

      it 'raise a parse if trailing' do
        lambda{
          parse("bblh # hello\ntrailing")
        }.should raise_error(Citrus::ParseError)
      end

      it 'raise a parse error otherwise' do
        lambda{
          parse("bblh # hello")
        }.should raise_error(Citrus::ParseError)
      end

    end
  end
end
