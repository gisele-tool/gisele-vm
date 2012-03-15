require 'spec_helper'
module Gisele
  class VM
    describe Command, "vm" do

      subject do
        c = Command.new
        c.parse_options argv
        c.vm(Path.dir/'code.gis')
      end
      let(:components){ subject.components }

      after do
        components.any?{|c| c.is_a?(ProgList)}.should be_true
        components.any?{|c| c.is_a?(EventManager)}.should be_true
      end

      context 'without options' do
        let(:argv){ [] }
        it 'should have an Enacter' do
          components.any?{|c| c.is_a?(Enacter)}.should be_true
        end
      end

      context 'with --simulate' do
        let(:argv){ ["--simulate"] }
        it 'should have Simulator agents' do
          pending{
            components.any?{|c| c.is_a?(Simulator::Resumer)}.should be_true
            components.any?{|c| c.is_a?(Simulator::Starter)}.should be_true
          }
        end
      end

      context 'with --interactive' do
        let(:argv){ ["--interactive"] }
        it 'should have an Interactive agent' do
          components.any?{|c| c.is_a?(Command::Interactive)}.should be_true
        end
      end

      context 'with --storage' do
        let(:argv){ ["--storage=postgres://localhost/gvm"] }
        it 'sets the options on ProgList correctly' do
          subject.proglist.options[:uri].should eq("postgres://localhost/gvm")
        end
      end

    end
  end
end
