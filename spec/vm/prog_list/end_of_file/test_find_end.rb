require 'spec_helper'
class Gisele::VM::ProgList
  describe EndOfFile, 'find_end' do

    def find(mode = 'r', &bl)
      EndOfFile.send(:find_end, file, mode, &bl)
    end

    let(:file){ Path.dir/"afile.txt" }

    after do
      file.unlink rescue nil
    end

    context 'when __END__ can be found' do

      before do
        file.write("blah\nblih\nbluh\n__END__\n12")
      end

      it 'yields the file at the correct position' do
        find{|io| io.gets.should eq("12")}
      end

    end

    context 'when __END__ cannot be found but mode is r+' do

      before do
        file.write("blah\nblih\nbluh")
      end

      it 'adds it at the end' do
        find('r+'){|io| io.gets.should be_nil}
        file.read.index(/^__END__/).should_not be_nil
      end

    end

    context 'when __END__ cannot be found but mode is not r+' do

      before do
        file.write("blah\nblih\nbluh\n")
      end

      it 'adds it at the end' do
        lambda{
          find('r'){|io| }
        }.should raise_error(RuntimeError)
      end

    end

  end
end