require 'spec_helper'

RSpec.describe GoogleSubscriber::PubSubFactory do
  subject(:factory) { described_class.new_pub_sub(project_id: project_id, credentials: credentials) }
  let(:project_id) { 'proj-id' }
  let(:credentials_file_path) do
    File.expand_path(File.join(
      File.dirname(__FILE__), '../../fixtures/credentials.json'))
  end
  let(:credentials) { credentials_file_path }
  let(:pub_sub) { instance_double(Google::Cloud::PubSub) }

  before do
    allow(Google::Cloud::PubSub).to receive(:new).and_return(pub_sub)
  end

  it 'instantiates new pubsub' do
    expect(factory).to eq(pub_sub)
  end

  it 'instantiates with correct params' do
    factory
    expect(Google::Cloud::PubSub).to have_received(:new)
                                       .with(project_id: project_id, credentials: credentials)
  end

  context 'when no project_id' do
    let(:project_id) { nil }

    it 'raises ArgumentError' do
      expect { factory }.to raise_error(ArgumentError, 'subscription_project_id is required!')
    end
  end

  context 'when no credentials' do
    let(:credentials) { '' }

    it 'raises ArgumentError' do
      expect { factory }.to raise_error(ArgumentError, 'subscription_credentials are required!')
    end
  end

  context 'when credentials are globally set' do
    before do
      GoogleSubscriber.configure do |config|
        config.google_credentials = '/global/creds.json'
      end
    end

    it 'uses overridden credentials' do
      factory
      expect(Google::Cloud::PubSub).to have_received(:new)
                                         .with(project_id: project_id,
                                               credentials: credentials)
    end

    context 'when no overridden credentials' do
      let(:credentials) { nil }
      it 'uses global project id' do
        factory
        expect(Google::Cloud::PubSub).to have_received(:new)
                                           .with(project_id: project_id,
                                                 credentials: '/global/creds.json')
      end
    end
  end

  context 'when project_id is globally set' do
    before do
      GoogleSubscriber.configure do |config|
        config.google_project_id = 'project-id-for-all-subscribers-unless-overridden'
      end
    end

    it 'uses overridden project_id' do
      factory
      expect(Google::Cloud::PubSub).to have_received(:new)
                                         .with(project_id: project_id,
                                               credentials: credentials)
    end

    context 'when no overridden project_id' do
      let(:project_id) { nil }
      it 'uses global project id' do
        factory
        expect(Google::Cloud::PubSub).to have_received(:new)
                                           .with(project_id: 'project-id-for-all-subscribers-unless-overridden',
                                                 credentials: credentials)
      end
    end
  end

  context 'when credentials are JSON' do
    let(:credentials) { File.read(credentials_file_path) }

    it 'instantiates with correct params' do
      factory
      expect(Google::Cloud::PubSub).to have_received(:new)
                                         .with(project_id: project_id, credentials: JSON.parse(credentials))
    end
  end
end