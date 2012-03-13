require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Memory do
      subject{ @proglist ||= ProgList::Memory.new }
      it_should_behave_like "a Storage"
    end
  end
end
