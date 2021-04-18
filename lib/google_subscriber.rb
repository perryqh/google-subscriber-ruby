require 'google_subscriber/version'
require 'google_subscriber/logging'
require 'google_subscriber/subscription_starter'
require 'google_subscriber/graceful_shutdown'
require 'google_subscriber/subscriber_registry'
require 'google_subscriber/base_subscriber'
require 'google_subscriber/pub_sub_factory'

module GoogleSubscriber
  extend Logging
  extend SubscriberRegistry

  def self.configure
    yield self if block_given?
  end

  def self.boot
    GoogleSubscriber.logger.info('booting subscribers')
    load_subscribers
    active_subscribers = start_subscribers

    GracefulShutdown.handle_signals do
      begin
        sleep
      rescue Shutdown => e
        GoogleSubscriber.shutdown(active_subscribers)
        e.continue
      end
    end
  end

  def self.shutdown(active_subscribers)
    GoogleSubscriber.logger.info('shutting down subscribers')
    return if active_subscribers.nil?

    active_subscribers.each do |sub|
      begin
        sub.stop.wait!
      rescue => e
        # swallow error so the remaining active_subscribers can be shut down
        GoogleSubscriber.logger.error("Error shutting down #{sub}: #{e.message}")
      end

      GoogleSubscriber.logger.info('stopped subscriber(s)!')
    end
  end
end
