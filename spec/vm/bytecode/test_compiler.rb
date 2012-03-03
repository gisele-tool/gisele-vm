require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler do

        subject{
          Compiler.compile(ts)
        }

        it 'returns Bytecode' do
          subject.should be_a(Bytecode)
        end

        it 'returns expected bytecode' do
          subject.to_s.should eq((fixtures_path/'ts.gvm').read)
        end

      end
    end
  end
end
