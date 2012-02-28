require 'spec_helper'
class Gisele::VM::ProgList
  describe EndOfFile, 'load' do

    let(:file){ Path.dir/'afile.gvm' }

    before do
      file.write(<<-GVM.gsub(/^\s*/, '').strip)
        blah
        blih
        __END__
        {:uuid => 0, :parent => 0, :pc => 17}

        {:uuid => 1, :parent => 0, :pc => 5}

      GVM
    end

    after do
      file.unlink rescue nil
    end

    it 'loads the file correctly' do
      list = EndOfFile.new(file)
      expected = Relation([
        {:uuid => 0, :parent => 0, :pc => 17},
        {:uuid => 1, :parent => 0, :pc => 5}
      ])
      list.to_relation.project([:uuid, :parent, :pc]).should eq(expected)
    end

  end
end