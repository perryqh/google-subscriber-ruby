require "google/cloud/pubsub"

module GoogleSubscriber
  module PubSubFactory
    def self.new_pub_sub(project_id, credentials)
      raise ArgumentError, 'subscription_project_id is required!' if blank?(project_id)
      raise ArgumentError, 'subscription_credentials are required!' if blank?(credentials)

      Google::Cloud::PubSub.new(project_id: project_id,
                                credentials: build_credentials(credentials))
    end

    def self.blank?(str)
      str.nil? || str.empty?
    end

    # If creds are a file-path, just return them. If they're JSON, convert to a hash
    #
    # @param [String] creds The path to credentials JSON file or the actual JSON
    def self.build_credentials(credentials)
      JSON.parse(credentials)
    rescue JSON::ParserError
      credentials
    end
  end
end