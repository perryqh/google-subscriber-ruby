require 'google_subscriber/version'
require 'google_subscriber/logging'
require 'google_subscriber/graceful_shutdown'
require 'google_subscriber/subscriber_registry'
require 'google_subscriber/base_subscriber'

module GoogleSubscriber
  extend Logging
  extend SubscriberRegistry

  def self.configure
    yield self if block_given?
  end
end
