require 'spec_helper'
module Gisele
  class VM

    shared_examples_for "A valid example file" do

      it 'respect the .gvm grammar' do
        Bytecode.coerce(subject).verify!
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
