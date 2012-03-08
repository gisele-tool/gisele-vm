require 'spec_helper'
module Gisele
  class VM
    describe EventManager do
      subject{ EventManager.new }
      it_should_behave_like "a component"
    end
  end
end
