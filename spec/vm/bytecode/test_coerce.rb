require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '.coerce' do

      it 'coerces bytecode' do
        b = Bytecode.new [:gvm]
        Bytecode.coerce(b).should eq(b)
      end

      it 'coerces a Path' do
        Bytecode.coerce(Path.dir/'bytecode.gvm').should be_a(Bytecode)
      end

      it 'coerces a String' do
        Bytecode.coerce("s0: push 12").should be_a(Bytecode)
      end

      it 'coerces a valid Gvm parse result' do
        sexpr = Gvm.sexpr(Path.dir/'bytecode.gvm')
        Bytecode.coerce(sexpr).should be_a(Bytecode)
      end

      it 'raises an InvalidBytecodeError when not recognized' do
        lambda{
          Bytecode.coerce(self)
        }.should raise_error(InvalidBytecodeError)
        lambda{
          Bytecode.coerce([:gvm, [:block, :s0, [:puts]]])
        }.should raise_error(InvalidBytecodeError)
      end

    end
  end
end
