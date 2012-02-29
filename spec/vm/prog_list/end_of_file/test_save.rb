require 'spec_helper'
class Gisele::VM::ProgList
  describe EndOfFile, 'save' do

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

    it 'saves the file correctly' do
      list = EndOfFile.new(file)
      prog = list.fetch(1)
      prog.pc = 15
      list.save(prog)

      expected = Relation([
        {:puid => 0, :parent => 0, :pc => 17},
        {:puid => 1, :parent => 0, :pc => 15}
      ])
      list.to_relation.project([:puid, :parent, :pc]).should eq(expected)

      list2 = EndOfFile.new(file)
      list2.to_relation.project([:puid, :parent, :pc]).should eq(expected)
    end

    it 'truncates the file before saving' do
      EndOfFile.new(file, true)
      list = EndOfFile.new(file)
      list.to_relation.should be_empty
    end

  end
end
