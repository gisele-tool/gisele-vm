require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Builder, "to_a" do

        let(:builder){ Builder.new(namespace) }

        before do
          builder.at(:s0) do |b|
            b.then :s1
          end
          builder.at(:s1) do |b|
            b.push 12
          end
        end

        context 'without namespace' do
          let(:namespace){ nil }

          it 'returns blocks' do
            expected = [ :gvm,
              [:block, :s0, [:then, :s1]],
              [:block, :s1, [:push, 12 ]],
            ]
            builder.to_a.should eq(expected)
          end

          it 'returns valid bytecode' do
            (Grammar === builder.to_a).should be_true
          end
        end

        context 'without namespace' do
          let(:namespace){ 'Somewhere' }

          it 'uses namespaced labels' do
            expected = [ :gvm,
              [:block, :Somewhere_s0, [:then, :Somewhere_s1]],
              [:block, :Somewhere_s1, [:push, 12 ]],
            ]
            builder.to_a.should eq(expected)
          end

          it 'returns valid bytecode' do
            (Grammar === builder.to_a).should be_true
          end
        end

      end
    end
  end
end
