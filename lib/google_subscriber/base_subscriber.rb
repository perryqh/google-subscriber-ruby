module GoogleSubscriber
  class BaseSubscriber
    class << self
      attr_reader :base_subscriber_name

      # Macro for specifying the subscriber name.
      # Naming convention:
      # subscriber_env_name = ENV["SUBSCRIPTION_#{subscriber_name}_ID"]
      # credential_env_name = ENV["SUBSCRIPTION_#{subscriber_name}_CREDENTIALS"]
      # project_id_env_name = ENV["SUBSCRIPTION_#{subscriber_name}_PROJECT_ID"]
      #
      # @param [String] name The subscriber name
      def subscriber_name(name)
        @base_subscriber_name = name
        GoogleSubscriber.register_subscriber(self)
      end
    end
  end
end