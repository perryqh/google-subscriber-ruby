class FooSubscriber < GoogleSubscriber::BaseSubscriber
  subscription_id 'my-subscription-id'
  subscription_credentials '/path/to/cred/file'
  # subscription_credentials or_actual_creds_json.to_json
  subscription_project_id 'my-gcp-project'
  subscription_listen_args({ threads: { callback: 16 } })

  attr_reader :received_messages

  def on_received_message(message)
    process(message)
    message.acknowledge!
  end
end