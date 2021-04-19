require 'logger'

module GoogleSubscriber
  module Configuration
    attr_writer :logger
    attr_accessor :google_credentials, :google_project_id, :subscription_listen_args

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
  extend GoogleSubscriber::Configuration
end
