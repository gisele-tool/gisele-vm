require 'spec_helper'
module Gisele
  class VM
    describe Gvm do

      it 'recognizes bad instructions' do
        (Gvm[:instruction] === [:push, 12]).should be_true
        (Gvm[:instruction] === [:push]).should be_false
      end

      it 'recognizes bad blocks' do
        (Gvm[:block] === [:block]).should be_false
        (Gvm[:block] === [:block, 0]).should be_false
        (Gvm[:block] === [:block, 0, [:push]]).should be_false
        (Gvm[:block] === [:block, 0, [:push, 12]]).should be_true
      end

      it 'recognize bad files' do
        (Gvm === [:gvm, [:block, 0, [:push]]]).should be_false
        (Gvm === [:gvm, [:block, 0, [:push, 12]]]).should be_true
      end

    end
  end
end
