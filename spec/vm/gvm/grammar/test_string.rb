require 'spec_helper'
module Gisele
  class VM
    describe Gvm, "string" do

      def parse(src)
        Gvm.parse(src, :root => :string)
      end

      it 'parses single quoted strings' do
        parse("'hello'").value.should eq("hello")
      end

      it 'parses double quoted strings' do
        parse('"hello"').value.should eq("hello")
      end

      it 'parses empty strings' do
        parse("''").value.should eq("")
        parse('""').value.should eq("")
      end

    end
  end
end
