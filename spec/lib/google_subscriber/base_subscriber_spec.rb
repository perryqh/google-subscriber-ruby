require 'spec_helper'

RSpec.describe GoogleSubscriber::BaseSubscriber do
  class TestClass < GoogleSubscriber::BaseSubscriber
    attr_reader :received_message
    subscriber_name :foo

    def on_received_message(received_message)
      @received_message = received_message
    end
  end

  subject { TestClass }

  it 'sets the subscriber_name' do
    expect(subject.base_subscriber_name).to eq(:foo)
  end
end