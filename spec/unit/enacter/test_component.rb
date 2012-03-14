require 'spec_helper'
module Gisele
  class VM
    describe Enacter do
      subject{ Enacter.new }
      pending{
        it_should_behave_like "a component"
      }
    end
  end
end
