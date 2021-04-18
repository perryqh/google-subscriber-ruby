module GoogleSubscriber
  module LifeCycle
    def boot
      GoogleSubscriber.logger.info('booting subscribers')
      load_subscribers
      active_subscribers = start_subscribers

      GracefulShutdown.handle_signals do
        begin
          sleep
        rescue Shutdown => e
          GoogleSubscriber.shutdown(active_subscribers)
          e.continue
        end
      end
    end

    def shutdown(active_subscribers)
      GoogleSubscriber.logger.info('shutting down subscribers')
      return if active_subscribers.nil?

      active_subscribers.each do |sub|
        begin
          sub.stop.wait!
        rescue => e
          # swallow error so the remaining active_subscribers can be shut down
          GoogleSubscriber.logger.error("Error shutting down #{sub}: #{e.message}")
        end

        GoogleSubscriber.logger.info('stopped subscriber(s)!')
      end
    end
  end
end