require 'spec_helper'
module Gisele
  class VM
    describe GvmFile, "block" do

      def parse(src)
        GvmFile.parse(src, :root => :block)
      end

      it 'parses a block with one instruction' do
        expected = [:block, 0, [:dump] ]
        parse(<<-BLOCK.strip).value.should eq(expected)
          0:  dump
        BLOCK
      end

      it 'parses a block with two instructions' do
        expected = [:block, 0, [:dump], [:pop, 3] ]
        parse(<<-BLOCK.strip).value.should eq(expected)
          0:  dump
              pop 3
        BLOCK
      end

      it 'supports comments' do
        expected = [:block, 0, [:dump], [:pop, 3] ]
        parse(<<-BLOCK.strip).value.should eq(expected)
          0:  dump     # blah
              pop 3    # blih
        BLOCK
      end

    end
  end
end