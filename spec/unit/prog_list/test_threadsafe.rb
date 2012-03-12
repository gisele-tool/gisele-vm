require 'spec_helper'
module Gisele
  class VM
    describe ProgList::Threadsafe do
      subject{ @proglist ||= ProgList::Memory.new.threadsafe }
      it_should_behave_like "a Storage"
    end
  end
end
