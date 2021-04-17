# frozen_string_literal: true

module GoogleSubscriber
  module SubscriberRegistry
    attr_writer :subscriber_paths

    def subscriber_paths
      @subscriber_paths ||= []
    end

    def load_subscribers
      subscriber_paths.each do |dir|
        Dir[File.join(dir, '*.rb')].each { |f| require f }
      end
    end

    def registry
      @registry ||= []
    end

    def register_subscriber(klass)
      GoogleSubscriber.logger.info("[#{name}#register_subscriber] Registered subscriber '#{klass.name}'")
      registry << klass unless registry.include?(klass)
    end

    def start_subscribers
      registry.collect(&:start)
    end
  end
end