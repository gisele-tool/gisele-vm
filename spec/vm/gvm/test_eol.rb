require 'spec_helper'
module Gisele
  class VM
    describe GvmFile, "eol" do

      def parse(src)
        GvmFile.parse(src, :root => :eol)
      end

      it 'parses \n' do
        parse("\n").value.should eq("\n")
      end

      it 'parses eof' do
        parse("").value.should eq("")
      end

    end
  end
end