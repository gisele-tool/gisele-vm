require 'spec_helper'
module Gisele
  class VM

    shared_examples_for "A valid example file" do

      it 'respect the .gvm grammar' do
        sexpr = Bytecode::Grammar.sexpr(subject)
        unless (Bytecode::Grammar === sexpr)
          sexpr.sexpr_body.each do |block|
            next if Bytecode::Grammar[:block]===block
            block.sexpr_body[1..-1].each do |i|
              raise "Bad instruction: #{i}" unless Bytecode::Grammar[:instruction]===i
            end
          end
        end
      end

    end # A valid example file

    examples = Path.backfind('.[examples]')/:examples
    examples.glob("**/*.gvm").each do |file|
      describe "the example #{file.basename}" do
        subject{file}
        it_behaves_like "A valid example file"
      end
    end

    fixtures.glob("**/*.gvm").each do |file|
      describe "the fixture #{file.basename}" do
        subject{file}
        it_behaves_like "A valid example file"
      end
    end

  end
end
