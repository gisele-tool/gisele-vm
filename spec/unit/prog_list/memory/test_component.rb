require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Memory do
      subject{ ProgList::Memory.new }
      it_should_behave_like "a component"
    end
  end
end
