require 'spec_helper'

RSpec.describe GoogleSubscriber::LifeCycle do
  let(:containing_module) { GoogleSubscriber }
  describe '#boot' do
    before do
      allow(containing_module).to receive(:load_subscribers)
      allow(containing_module).to receive(:start_subscribers)
      allow(containing_module::GracefulShutdown).to receive(:trap)
      allow(containing_module).to receive(:sleep)
      containing_module.boot
    end

    it 'loads subscribers' do
      expect(containing_module).to have_received(:load_subscribers)
    end

    it 'starts subscribers' do
      expect(containing_module).to have_received(:start_subscribers)
    end

    it 'traps TERM' do
      expect(containing_module::GracefulShutdown).to have_received(:trap).with('TERM')
    end

    it 'traps INT' do
      expect(containing_module::GracefulShutdown).to have_received(:trap).with('INT')
    end

    it 'sleeps' do
      expect(containing_module).to have_received(:sleep)
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
      expect(containing_module.shutdown(nil)).to be_nil
    end

    it 'handles empty active_subscribers' do
      expect(containing_module.shutdown([])).to be_empty
    end

    it 'stops and waits subscribers' do
      containing_module.shutdown([subscriber])
      expect(stop).to have_received(:wait!)
    end

    it 'continues to stop subscribers even if errors are encountered' do
      containing_module.shutdown([error_subscriber, subscriber])
      expect(stop).to have_received(:wait!)
    end
  end
end