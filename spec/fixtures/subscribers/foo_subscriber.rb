class FooSubscriber < GoogleSubscriber::BaseSubscriber
  attr_reader :received_messages

  def on_received_message(message)
    @received_messages ||= []
    @received_messages << message
  end
end