require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "label" do

      def parse(src)
        Gvm.parse(src, :root => :label)
      end

      it 'parses a label, including the :' do
        parse("alabel:").value.should eq(:alabel)
      end

      it 'allows pure numerics' do
        parse("0:").value.should eq(0)
      end

      it 'allows pure alphanums' do
        parse("blah0:").value.should eq(:blah0)
      end

    end
  end
end