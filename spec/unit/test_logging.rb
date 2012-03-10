require 'spec_helper'
module Gisele
  class VM
    describe Logging do
      include Logging

      context 'without logger' do

        it 'does not fail when logging message' do
          info("something").should be_a(NullObject)
          fatal("an error occured").something_else.should be_a(NullObject)
        end

        it 'returns false on query methods' do
          if info?
            true.should be_false
          end
        end

      end # without logger

      context 'with a logger' do

        before do
          self.logger = Object.new
          def logger.info?
            true
          end
          def logger.info(msg)
            @msg = msg.upcase
          end
        end

        it 'delegates logging calls' do
          info("something to log").should eq("SOMETHING TO LOG")
        end

        it 'delegates query methods' do
          info?.should be_true
        end

      end # with a logger

    end
  end
end
