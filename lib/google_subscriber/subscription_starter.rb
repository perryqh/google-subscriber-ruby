module GoogleSubscriber
  module SubscriptionStarter
    DEFAULT_SUBSCRIPTION_LISTEN_ARGS = {}.freeze

    # Listens for new messages associated with the subscriber name
    # As messages come in, `on_received_message` is called, which must be overridden on subclasses
    def start
      subscriber = new
      pub_sub_subscriber = create_subscription.listen(build_listen_args) do |received_message|
        # Rails.application.reloader.wrap do
        subscriber.on_received_message(received_message)
        # end
      end

      pub_sub_subscriber.start
      GoogleSubscriber.logger.info("[#{name}.start] Started subscriber with subscription '#{g_subscription_id}'")

      pub_sub_subscriber
    end

    def build_listen_args
      DEFAULT_SUBSCRIPTION_LISTEN_ARGS.merge(g_subscription_listen_args || {})
    end

    def create_subscription
      raise ArgumentError, 'subscription_id is required!' if g_subscription_id.nil?

      GoogleSubscriber::PubSubFactory.new_pub_sub(g_project_id, g_credentials)
                                     .subscription(g_subscription_id&.to_s)
    end
  end
end