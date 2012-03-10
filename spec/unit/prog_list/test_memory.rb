module Gisele
  class VM
    describe ProgList::Memory do
      subject{ @proglist ||= ProgList.memory }
      it_should_behave_like "a ProgList"
    end
  end
end
