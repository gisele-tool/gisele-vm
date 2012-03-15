require 'spec_helper'
module Gisele
  class VM
    describe EventManager, 'subscribe' do

      let(:publisher) { EventManager.new }
      let(:subscriber){ lambda{|event| } }

      after do
        publisher.subscribed?(subscriber).should be_true
      end

      context 'when not connected' do
        it 'subscribes a block correctly' do
          publisher.subscribe(&subscriber)
        end
        it 'subscribes a Proc correctly' do
          publisher.subscribe(subscriber)
        end
      end

      context 'when connected' do
        before do
          publisher.registered(vm)
          publisher.connect
        end
        after do
          publisher.send(:name_of, subscriber).should_not be_nil
        end
        it 'subscribes a block to EM' do
          publisher.subscribe(&subscriber)
        end
        it 'subscribes a Proc to EM' do
          publisher.subscribe(subscriber)
        end
      end

    end
  end
end
