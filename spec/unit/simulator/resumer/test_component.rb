require 'spec_helper'
module Gisele
  class VM
    class Simulator
      describe Resumer do
        subject{ Resumer.new }
        it_should_behave_like "a component"
      end
    end
  end
end
