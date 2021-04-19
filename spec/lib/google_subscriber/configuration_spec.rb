require 'spec_helper'

RSpec.describe GoogleSubscriber::Configuration do
  before do
    GoogleSubscriber.logger = nil
  end
  after do
    GoogleSubscriber.logger = nil
  end

  describe 'google configuration' do
    before do
      GoogleSubscriber.configure do |google_subscriber|
        google_subscriber.google_credentials = '/path/to/credentials.json'
        google_subscriber.google_project_id = 'the-gcp-id'
        google_subscriber.subscription_listen_args = { foo: :bar }
      end

      it 'sets google credentials' do
        expect(GoogleSubscriber.google_credentials).to eq('/path/to/credentials.json')
        expect(GoogleSubscriber.google_project_id).to eq('the-gcp-id')
        expect(GoogleSubscriber.subscription_listen_args).to eq({ foo: :bar })
      end
    end
  end

  describe '#logger' do
    it 'sets the logger to use' do
      MyLogger = Class.new
      GoogleSubscriber.logger = MyLogger
      expect(GoogleSubscriber.logger).to eq(MyLogger)
    end

    it 'defaults to Ruby Logger' do
      expect(GoogleSubscriber.logger).to be_a(Logger)
    end

    it 'defaults to Logger writing to STDOUT' do
      allow(Logger).to receive(:new)
      GoogleSubscriber.logger
      expect(Logger).to have_received(:new).with(STDOUT)
    end
  end
end