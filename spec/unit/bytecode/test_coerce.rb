require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '.coerce' do

      def coerce(source)
        @result = Bytecode.coerce(source)
      end

      after do
        @result.should be_a(Bytecode) if @result
      end

      it 'coerces bytecode' do
        coerce(Bytecode.new [:gvm])
      end

      it 'coerces a String' do
        coerce("s0: push 12")
      end

      it 'coerces a .gvm Path' do
        coerce(fixtures/'ts.gvm')
      end

      it 'coerces a valid parse result' do
        coerce(Bytecode::Grammar.sexpr(fixtures/'ts.gvm'))
      end

      it 'raises an InvalidBytecodeError when not recognized' do
        lambda{
          coerce(self)
        }.should raise_error(ArgumentError)
        lambda{
          coerce([:gvm, [:block, :s0, [:puts]]])
        }.should raise_error(ArgumentError)
      end

    end
  end
end
