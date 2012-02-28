require 'spec_helper'
module Gisele
  class VM
    describe GvmFile, "instruction" do

      def parse(src)
        GvmFile.parse(src, :root => :instruction)
      end

      it 'parses an instruction without arg' do
        parse("dump").value.should eq([:dump])
      end

      it 'parses an instruction with an arg' do
        parse("dump 0").value.should eq([:dump, 0])
      end

      it 'parses an instruction with two args' do
        parse("dump 0, 'blah'").value.should eq([:dump, 0, "blah"])
      end

      it 'supports tailing spaces' do
        parse("dump 0, 'blah'    ").value.should eq([:dump, 0, "blah"])
      end

      it 'supports comments' do
        parse("dump 0, 'blah'   # a comment").value.should eq([:dump, 0, "blah"])
      end

    end
  end
end