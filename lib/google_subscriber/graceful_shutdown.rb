module GoogleSubscriber
  class GracefulShutdown
    DEFAULT_SIGNALS = %w(INT TERM)

    class << self
      def handle_signals(*signals)
        signals = DEFAULT_SIGNALS if signals.empty?
        handlers = setup(signals)
        yield if block_given?
        teardown(handlers)
      rescue Shutdown
        exit
      end

      private

      def setup(signals)
        signals.each_with_object({}) do |signal, handlers|
          handlers[signal] = trap(signal) do
            raise Shutdown
          end
        end
      end

      def teardown(handlers)
        handlers.each do |signal, handler|
          trap(signal, handler)
        end
      end
    end
  end

  class Shutdown < RuntimeError
    def continue
      raise self
    end

    def ignore
      # No-op, provided for clarity.
    end
  end
end