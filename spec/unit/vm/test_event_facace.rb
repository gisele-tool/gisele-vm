require 'spec_helper'
module Gisele
  describe VM, "the proglist facade" do

    let(:vm){
      VM.new do |vm|
        vm.event_manager = Proc.new{|*args| @args = args}
      end
    }

    it 'delegates event calls to it' do
      vm.event(:hello, [17, "World"])
      @args.should eq([:hello, [17, "World"]])
    end

  end
end
