require 'google-subscriber'
require 'rails'

module GoogleSubscriber
  class Railtie < Rails::Railtie
    railtie_name :google_subscriber

    rake_tasks do
      load 'tasks/google_subscriber.rake'
    end
  end
end