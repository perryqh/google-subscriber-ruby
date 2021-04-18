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
end