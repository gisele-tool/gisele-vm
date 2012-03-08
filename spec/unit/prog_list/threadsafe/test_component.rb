require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Threadsafe do
      subject{ ProgList::Threadsafe.new(self) }
      it_should_behave_like "a component"
    end
  end
end
