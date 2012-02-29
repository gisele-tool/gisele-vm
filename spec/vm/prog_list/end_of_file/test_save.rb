require 'spec_helper'
class Gisele::VM::ProgList
  describe EndOfFile, 'save' do

    let(:file){ Path.dir/'afile.gvm' }

    before do
      file.write("blah\nblih\n__END__\n{:puid => 0, :parent => 0, :pc => 17}\n{:puid => 1, :parent => 0, :pc => 5}")
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

  end
end
