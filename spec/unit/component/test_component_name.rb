require 'spec_helper'
module Gisele
  class VM
    describe Component, "component_name" do

      class FooComponent < VM::Component
        public :component_name
      end

      it 'uses the class name by default' do
        FooComponent.new.component_name.should eq("FooComponent")
      end

    end
  end
end
