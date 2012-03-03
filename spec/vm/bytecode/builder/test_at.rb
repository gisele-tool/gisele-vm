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

      end
    end
  end
end
