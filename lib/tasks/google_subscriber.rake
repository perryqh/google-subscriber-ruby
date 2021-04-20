require 'google-subscriber'

namespace :google_subscriber do
  desc 'start pub/sub subscribers'
  task start_subscribers: :environment do
    GoogleSubscriber.boot
  end
end