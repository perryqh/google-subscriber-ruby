require 'spec_helper'

RSpec.describe GoogleSubscriber::SubscriberRegistry do
  class TestSubscriber < GoogleSubscriber::BaseSubscriber
    subscriber_name 'test'
  end

  describe '#register_subscriber' do
    before do
      GoogleSubscriber.registry.clear
      GoogleSubscriber.register_subscriber(TestSubscriber)
    end
    it 'adds to registry' do
      expect(GoogleSubscriber.registry).to eq([TestSubscriber])
    end

    describe '#start_subscribers' do
      before do
        allow(TestSubscriber).to receive(:start)
      end
      it 'starts registered subscribers' do
        GoogleSubscriber.start_subscribers
        expect(TestSubscriber).to have_received(:start)
      end
    end

    describe '#load_subscribers' do
      before do
        GoogleSubscriber.subscriber_paths << File.expand_path(File.join(File.dirname(__FILE__), '../..', 'fixtures/subscribers'))
      end

      it 'requires files in subscriber_paths' do
        expect(defined?(FooSubscriber)).to be_falsey
        GoogleSubscriber.load_subscribers
        expect(defined?(FooSubscriber)).to be_truthy
      end
    end
  end
end