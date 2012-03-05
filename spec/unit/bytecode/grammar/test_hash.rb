require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar, "hash" do

      def parse(src)
        Bytecode::Grammar.parse(src, :root => :hash)
      end

      it 'parses empty hashes correctly' do
        parse("{}").value.should eq({})
      end

      it 'parses singletons correctly' do
        parse("{key: 12}").value.should eq({:key => 12})
      end

      it 'parses hashes correctly' do
        parse("{key: 12, name: 'blaj'}").value.should eq({:key => 12, :name => 'blaj'})
      end

      it 'parses event dict' do
        expected = {:hello => :s2, :goodbye => :s3}
        parse("{hello: :s2, goodbye: :s3}").value.should eq(expected)
      end

      it 'supports 1.8 syntax' do
        parse("{:key => 12, :name => 'blaj'}").value.should eq({:key => 12, :name => 'blaj'})
      end

    end
  end
end
