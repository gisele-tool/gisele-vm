require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Builder, "the pseudo method-missing helpers" do

        let(:builder){ Builder.new("Somewhere") }

        before do
          builder.at(:s0)
        end

        after do
          builder.end_block
        end

        it 'returns the instruction built' do
          builder.push(12).should eq([:push, 12])
        end

        it 'provides auto-labeling on :then' do
          builder.then(:s1).should eq([:then, :Somewhere_s1])
        end

        it 'allows disabling auto-labeling on :then' do
          builder.then(:s1, false).should eq([:then, :s1])
        end

      end
    end
  end
end
