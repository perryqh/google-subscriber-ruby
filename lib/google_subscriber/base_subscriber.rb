module GoogleSubscriber
  class BaseSubscriber
    extend SubscriptionStarter

    # Subclasses must override this method or method(s) of the form `on_received_#{message.data_event}_message`.
    # It is called as messages are received
    # Remember to acknowledge the `received_message` https://googleapis.dev/ruby/google-cloud-pubsub/latest/Google/Cloud/PubSub/ReceivedMessage.html
    #
    # @param [Class: Google::Cloud::PubSub::ReceivedMessage] _received_message The received_message
    def on_received_message(_received_message)
      raise 'must override!'
    end

    class << self
      attr_reader :g_subscription_id, :g_credentials, :g_project_id, :g_subscription_listen_args

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

      # https://rubydoc.info/gems/google-cloud-pubsub/2.5.0/Google/Cloud/PubSub/Subscription#listen-instance_method
      def subscription_listen_args(args)
        @g_subscription_listen_args = args
      end
    end
  end
end