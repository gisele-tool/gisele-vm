require 'spec_helper'
module Gisele
  class VM
    class Simulator
      describe Starter do
        subject{ Starter.new }
        it_should_behave_like "a component"
      end
    end
  end
end
