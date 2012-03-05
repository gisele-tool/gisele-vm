require 'spec_helper'
module Gisele
  class VM
    describe Bytecode::Grammar do

      it 'recognizes bad instructions' do
        (Bytecode::Grammar[:instruction] === [:push, 12]).should be_true
        (Bytecode::Grammar[:instruction] === [:push]).should be_false
      end

      it 'recognizes bad blocks' do
        (Bytecode::Grammar[:block] === [:block]).should be_false
        (Bytecode::Grammar[:block] === [:block, 0]).should be_false
        (Bytecode::Grammar[:block] === [:block, 0, [:push]]).should be_false
        (Bytecode::Grammar[:block] === [:block, 0, [:push, 12]]).should be_true
      end

      it 'recognize bad files' do
        (Bytecode::Grammar === [:gvm, [:block, 0, [:push]]]).should be_false
        (Bytecode::Grammar === [:gvm, [:block, 0, [:push, 12]]]).should be_true
      end

      it 'provides the list of instruction names' do
        Bytecode::Grammar.instructions.should be_a(Array)
        Bytecode::Grammar.instructions.include?(:push).should be_true
      end

    end
  end
end
