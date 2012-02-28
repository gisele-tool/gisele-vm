require 'spec_helper'
module Gisele
  class VM
    describe GvmFile, "file" do

      def parse(src)
        GvmFile.parse(src)
      end

      it 'returns an array if all symbols are integers' do
        expected = [[ [:dump], [:pop, 3] ], [ [:hello] ]]
        parse(<<-BLOCK.strip).value.should eq(expected)
          0: dump
             pop 3
          1: hello
        BLOCK
      end

      it 'returns a hash if not all symbols are integers' do
        expected = {:a => [ [:dump], [:pop, 3] ], :b => [ [:hello] ] }
        parse(<<-BLOCK.strip).value.should eq(expected)
          a: dump
             pop 3
          b: hello
        BLOCK
      end

      Dir[File.expand_path('../fixtures/*.gvm', __FILE__)].each do |file|

        it "parses #{File.basename(file)}" do
          parse(File.read(file)).value.should be_a(Array)
        end

      end

    end
  end
end