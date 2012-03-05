require 'spec_helper'
class Gisele::VM
  class ProgList
    describe EndOfFile, 'load' do

      let(:file){ Path.dir/'afile.gvm' }

      before do
        file.write(<<-GVM.gsub(/^\s*/, '').strip)
          blah
          blih
          __END__
          {:puid => 0, :parent => 0, :pc => 17}

          {:puid => 1, :parent => 0, :pc => 5}

        GVM
      end

      after do
        file.unlink rescue nil
      end

      it 'loads the file correctly' do
        list = ProgList.end_of_file(file)
        expected = Relation([
          {:puid => 0, :parent => 0, :pc => 17},
          {:puid => 1, :parent => 0, :pc => 5}
        ])
        list.to_relation.project([:puid, :parent, :pc]).should eq(expected)
      end

    end
  end
end
