require 'spec_helper'

RSpec.describe GoogleSubscriber do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  describe '#boot' do
    before do
      allow(described_class).to receive(:load_subscribers)
      allow(described_class).to receive(:start_subscribers)
      allow(described_class::GracefulShutdown).to receive(:trap)
      allow(described_class).to receive(:sleep)
      described_class.boot
    end

    it 'loads subscribers' do
      expect(described_class).to have_received(:load_subscribers)
    end

    it 'starts subscribers' do
      expect(described_class).to have_received(:start_subscribers)
    end

    it 'traps TERM' do
      expect(described_class::GracefulShutdown).to have_received(:trap).with('TERM')
    end

    it 'traps INT' do
      expect(described_class::GracefulShutdown).to have_received(:trap).with('INT')
    end

    it 'sleeps' do
      expect(described_class).to have_received(:sleep)
    end
  end

  describe '#shutdown' do
    let(:stop) { double(:stop) }
    let(:subscriber) { double(:subscriber, stop: stop) }
    let(:error_subscriber) { double(:subscriber) }
    before do
      allow(stop).to receive(:wait!)
      allow(error_subscriber).to receive(:stop).and_raise('boom!')
    end

    it 'handles nil active_subscribers' do
      expect(described_class.shutdown(nil)).to be_nil
    end

    it 'handles empty active_subscribers' do
      expect(described_class.shutdown([])).to be_empty
    end

    it 'stops and waits subscribers' do
      described_class.shutdown([subscriber])
      expect(stop).to have_received(:wait!)
    end

    it 'continues to stop subscribers even if errors are encountered' do
      described_class.shutdown([error_subscriber, subscriber])
      expect(stop).to have_received(:wait!)
    end
  end
end