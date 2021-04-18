require 'spec_helper'

RSpec.describe GoogleSubscriber::SubscriptionStarter do
  subject(:base_subscriber) { FooSubscriber }

  describe '#start' do
    let!(:subscriber_instance) { FooSubscriber.new }
    let(:pub_sub) { instance_double(Google::Cloud::PubSub::Project) }
    let(:subscription) { instance_double(Google::Cloud::PubSub::Subscription) }
    let(:pub_sub_subscriber) { instance_double(Google::Cloud::PubSub::Subscriber) }
    let(:received_message) { instance_double(Google::Cloud::PubSub::ReceivedMessage) }

    before do
      allow(GoogleSubscriber::PubSubFactory).to receive(:new_pub_sub).and_return(pub_sub)
      allow(pub_sub).to receive(:subscription).and_return(subscription)
      allow(subscription).to receive(:listen).and_yield(received_message).and_return(pub_sub_subscriber)
      allow(pub_sub_subscriber).to receive(:start)
      allow(FooSubscriber).to receive(:new).and_return(subscriber_instance)

      expect(base_subscriber.start).to eq(pub_sub_subscriber)
    end

    it 'calls subscriber.on_received_message' do
      expect(subscriber_instance.received_messages).to eq([received_message])
    end

    it 'creates subscription using the provided subscription_id' do
      expect(pub_sub).to have_received(:subscription).with('my-subscription-id')
    end

    it 'listens with provided listen args' do
      expect(subscription).to have_received(:listen).with({ threads: { callback: 16 } })
    end

  #   context 'when Rails and ActiveRecord  defined' do
  #     after do
  #       Object.send(:remove_const, :Rails)
  #       ActiveRecord.send(:remove_const, :Base)
  #       Object.send(:remove_const, :ActiveRecord)
  #     end
  #
  #     before do
  #       Object.const_set('Rails', Class.new)
  #       Rails = eval('Rails')
  #       Rails.stub_chain(:application, :reloader, :wrap).and_yield
  #       Object.const_set('ActiveRecord', Module.new)
  #       ActiveRecord = eval('ActiveRecord')
  #       ActiveRecord.const_set('Base', Class.new)
  #       ActiveRecord::Base.stub_chain(:connection_pool, :with_connection).and_yield
  #     end
  #
  #     it 'calls subscriber.on_received_message' do
  #       expect(subscriber_instance.received_messages).to eq([received_message])
  #     end
  #   end
  end
end