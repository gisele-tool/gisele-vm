require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "constant" do

      def parse(src)
        Gvm.parse(src, :root => :constant)
      end

      it 'parses single constants correctly' do
        parse("Kernel").value.should eq(Kernel)
      end

      it 'parses qualified constants correctly' do
        parse("Gisele::VM").value.should eq(Gisele::VM)
      end

    end
  end
end