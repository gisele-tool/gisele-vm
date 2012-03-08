require 'spec_helper'
module Gisele
  class VM
    describe ProgList::EndOfFile do

      let(:file){ Path.dir/'afile.gvm' }

      before do
        file.write("")
      end

      subject{ ProgList::EndOfFile.new(file) }

      it_should_behave_like "a component"

      after do
        file.unlink rescue nil
      end

    end
  end
end
