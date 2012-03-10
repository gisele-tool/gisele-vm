require 'spec_helper'
module Gisele
  class VM
    describe Registry do
      subject{ Registry.new }
      it_should_behave_like "a component"
    end
  end
end
