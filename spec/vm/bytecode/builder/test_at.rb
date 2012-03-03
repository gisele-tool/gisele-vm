require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Builder, "at" do

        let(:builder){ Builder.new }

        it 'yields itself then returns the block' do
          r = builder.at(:s0) do |b|
            b.push 12
          end
          r.should eq([:block, :s0, [:push, 12]])
        end

        it 'allows a stack based usage' do
          builder.at(:s0)
          builder.instruction(:push, [12])
          builder.end_block.should eq([:block, :s0, [:push, 12]])
        end

        it 'raises a BadUsageError if the previous block has not been dumped' do
          builder.at(:s0)
          lambda{
            builder.at(:s1)
          }.should raise_error(BadUsageError)
        end

        context 'when namespaced' do
          let(:builder){ Builder.new('Somewhere') }

          it 'use namespaced labels' do
            builder.at(:s0)
            builder.end_block.should eq([:block, :Somewhere_s0])
          end

          it 'allows disabling auto labeling' do
            builder.at(:s0, false)
            builder.end_block.should eq([:block, :s0])
          end

        end

      end
    end
  end
end
