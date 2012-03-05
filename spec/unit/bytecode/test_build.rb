require 'spec_helper'
module Gisele
  class VM
    describe Bytecode, '.build' do

      subject{
        Bytecode.build(namespace) do |b|
          b.at(:s0) do
            b.push 12
          end
        end
      }

      context 'without namespace' do
        let(:namespace){ nil }

        it 'returns a Bytecode instance' do
          subject.should be_a(Bytecode)
        end

        it 'builds bytecode' do
          subject[:s0].should eq([ [:push, 12] ])
        end
      end

      context 'with a namespace' do
        let(:namespace){ "Somewhere" }

        it 'uses namespaced labels' do
          subject[:"Somewhere_s0"].should eq([ [:push, 12] ])
        end
      end

    end
  end
end
