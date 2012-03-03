require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, 'to_a' do

      let(:bytecode){
        Bytecode.coerce <<-BC.gsub(/^\s+/, '')
          s0: push 12
              pop
          a_long_label: push [12, "hello"]
                        push {:hello => :s1}
        BC
      }

      subject{ bytecode.to_s.strip }

      it 'should indent friendly' do
        subject.should eq(<<-STR.gsub(/^\s+\| /, '').strip)
          | s0:           push 12
          |               pop
          | a_long_label: push [12, "hello"]
          |               push {:hello=>:s1}
        STR
      end

      it 'should print equivalent bytecode' do
        Bytecode.parse(bytecode.to_s).to_a.should eq(bytecode.to_a)
      end

    end
  end
end
