require 'spec_helper'
module Gisele
  class VM
    describe EventManager, 'unsubscribe' do

      let(:publisher) { EventManager.new }
      let(:subscriber){ lambda{|event| } }

      after do
        publisher.subscribed?(subscriber).should be_false
      end

      context 'when not connected' do
        it 'does nothing when not previously subscribed' do
          publisher.unsubscribe(subscriber).should be_nil
        end
        it 'unsubscribes a block previously subscribed' do
          publisher.subscribe(subscriber)
          publisher.unsubscribe(subscriber)
        end
      end

      context 'when connected' do
        before do
          publisher.registered(vm)
          publisher.connect
        end
        after do
          publisher.send(:name_of, subscriber).should be_nil
        end
        it 'unsubscribes a Proc to EM' do
          publisher.subscribe(subscriber)
          publisher.unsubscribe(subscriber)
        end
      end

    end
  end
end
