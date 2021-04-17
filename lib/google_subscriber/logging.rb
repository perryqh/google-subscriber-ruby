require 'logger'

module GoogleSubscriber
  module Logging
    attr_writer :logger

    # Returns the logger
    # You can define the logger when you configure +GoogleSubscriber+ if you want to use a different logger than the default Ruby Logger.
    #
    # @see GoogleSubscriber.configure
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end

module GRPC
  extend GoogleSubscriber::Logging
end
