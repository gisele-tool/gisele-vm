require 'spec_helper'
class Gisele::VM::ProgList
  describe EndOfFile, 'save' do

    let(:file){ Path.dir/'afile.gvm' }

    before do
      file.write("blah\nblih\n__END__\n{:uuid => 0, :parent => 0, :pc => 17}\n{:uuid => 1, :parent => 0, :pc => 5}")
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
        {:uuid => 0, :parent => 0, :pc => 17},
        {:uuid => 1, :parent => 0, :pc => 15}
      ])
      list.to_relation.project([:uuid, :parent, :pc]).should eq(expected)

      list2 = EndOfFile.new(file)
      list2.to_relation.project([:uuid, :parent, :pc]).should eq(expected)
    end

  end
end