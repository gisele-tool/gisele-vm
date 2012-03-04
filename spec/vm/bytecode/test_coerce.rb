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

      it 'coerces a .gts Automaton' do
        coerce(Kernel.eval (fixtures/'ts.gts').read)
      end

      it 'coerces a String' do
        coerce("s0: push 12")
      end

      it 'coerces a .gvm Path' do
        coerce(fixtures/'ts.gvm')
      end

      it 'coerces a .adl Path' do
        coerce(fixtures/'ts.adl')
      end

      it 'coerces a .gts Path' do
        coerce(fixtures/'ts.gts')
      end

      it 'coerces a valid Gvm parse result' do
        coerce(Gvm.sexpr(fixtures/'ts.gvm'))
      end

      it 'raises an InvalidBytecodeError when not recognized' do
        lambda{
          coerce(self)
        }.should raise_error(InvalidBytecodeError)
        lambda{
          coerce([:gvm, [:block, :s0, [:puts]]])
        }.should raise_error(InvalidBytecodeError)
      end

    end
  end
end
