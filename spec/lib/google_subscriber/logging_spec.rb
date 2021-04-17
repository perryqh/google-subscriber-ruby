require 'spec_helper'

RSpec.describe GoogleSubscriber::Logging do
  before do
    GoogleSubscriber.logger = nil
  end
  after do
    GoogleSubscriber.logger = nil
  end

  describe '#logger' do
    it 'sets the logger to use' do
      MyLogger        = Class.new
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