module Gisele
  class VM
    describe ProgList::Threadsafe do
      subject{ @proglist ||= ProgList.memory.threadsafe }
      it_should_behave_like "a ProgList"
    end
  end
end
