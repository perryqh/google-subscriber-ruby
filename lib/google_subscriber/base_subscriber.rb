module GoogleSubscriber
  class BaseSubscriber
    class << self
      attr_reader :g_subscription_id, :g_credentials, :g_project_id

      # Macro for specifying the subscription_id
      # @param [String] subscription_id The subscription-id
      def subscription_id(subscription_id)
        @g_subscription_id = subscription_id
        GoogleSubscriber.register_subscriber(self)
      end

      def subscription_credentials(creds)
        @g_credentials = creds
      end

      def subscription_project_id(project_id)
        @g_project_id = project_id
      end
    end
  end
end