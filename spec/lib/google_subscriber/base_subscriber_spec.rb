require 'spec_helper'

RSpec.describe GoogleSubscriber::BaseSubscriber do
  class TestClass < GoogleSubscriber::BaseSubscriber
    attr_reader :received_message
    subscription_id :foo
    subscription_credentials '/path/to/cred/file'
    subscription_project_id 'my-gcp-project'
    subscription_listen_args({ threads: { callback: 16 } })

    def on_received_message(received_message)
      @received_message = received_message
    end
  end

  subject(:base_subscriber) { TestClass }

  it 'sets the subscription id' do
    expect(base_subscriber.g_subscription_id).to eq(:foo)
  end

  it 'sets the subscription credentials' do
    expect(base_subscriber.g_credentials).to eq('/path/to/cred/file')
  end

  it 'sets the subscription project id' do
    expect(base_subscriber.g_project_id).to eq('my-gcp-project')
  end

  describe '#start' do
    let!(:subscriber_instance) { TestClass.new }
    let(:pub_sub) { instance_double(Google::Cloud::PubSub::Project) }
    let(:subscription) { instance_double(Google::Cloud::PubSub::Subscription) }
    let(:pub_sub_subscriber) { instance_double(Google::Cloud::PubSub::Subscriber) }
    let(:received_message) { instance_double(Google::Cloud::PubSub::ReceivedMessage) }

    before do
      allow(GoogleSubscriber::PubSubFactory).to receive(:new_pub_sub).and_return(pub_sub)
      allow(pub_sub).to receive(:subscription).and_return(subscription)
      allow(subscription).to receive(:listen).and_yield(received_message).and_return(pub_sub_subscriber)
      allow(pub_sub_subscriber).to receive(:start)
      allow(TestClass).to receive(:new).and_return(subscriber_instance)

      expect(base_subscriber.start).to eq(pub_sub_subscriber)
    end

    it 'calls subscriber.on_received_message' do
      expect(subscriber_instance.received_message).to eq(received_message)
    end

    it 'creates subscription using the provided subscription_id' do
      expect(pub_sub).to have_received(:subscription).with('foo')
    end

    it 'listens with provided listen args' do
      expect(subscription).to have_received(:listen).with({ threads: { callback: 16 } })
    end
  end
end