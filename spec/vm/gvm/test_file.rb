require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "file" do

      def parse(src)
        Gvm.parse(src)
      end

      it 'returns a [:gvm] array' do
        expected = \
          [:gvm,
            [ :block, 0, [:dump], [:pop, 3] ],
            [ :block, 1, [:hello] ] ]
        parse(<<-BLOCK.strip).value.should eq(expected)
          0: dump
             pop 3
          1: hello
        BLOCK
      end

      (Path.dir/'fixtures').glob('*.gvm').each do |file|
        context "the fixture #{File.basename(file)}" do
          let(:sexpr){ Gvm.sexpr(file) }

          it "is parsed correctly" do
            sexpr.should be_a(Array)
          end

          it "respects the grammar" do
            (Gvm === sexpr).should be_true
          end
        end
      end

    end
  end
end