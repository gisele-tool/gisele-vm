require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Builder, "instruction" do

        let(:builder){ Builder.new }

        it 'adds an instruction to the current block' do
          builder.at(:s0) do |b|
            b.instruction(:push, [12])
          end
          expected = [:gvm, [:block, :s0, [:push, 12]] ]
          builder.to_a.should eq(expected)
        end

        it 'raises BadUsageError if no current block' do
          lambda{
            builder.instruction(:push, [ 12 ])
          }.should raise_error(BadUsageError)
        end

        it "raises InvalidBytecodeError if arguments don't match" do
          lambda{
            builder.instruction(:pop, ['blih'])
          }.should raise_error(InvalidBytecodeError)
          lambda{
            builder.instruction(:push, [])
          }.should raise_error(InvalidBytecodeError)
        end

      end
    end
  end
end
