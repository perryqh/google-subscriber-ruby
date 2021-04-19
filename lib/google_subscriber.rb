require 'google_subscriber/version'
require 'google_subscriber/configuration'
require 'google_subscriber/life_cycle'
require 'google_subscriber/subscription_starter'
require 'google_subscriber/graceful_shutdown'
require 'google_subscriber/subscriber_registry'
require 'google_subscriber/base_subscriber'
require 'google_subscriber/pub_sub_factory'

module GoogleSubscriber
  extend Configuration
  extend SubscriberRegistry
  extend LifeCycle

  def self.configure
    yield self if block_given?
  end
end
