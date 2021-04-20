# GoogleSubscriber

GoogleSubscribers discovers your ruby google pub/sub subscribers and provides a rake task for starting them

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google-subscriber'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install google-subscriber

## Usage

Add a google_subscriber.rb file to in your `Rails.root/config/initializers/` directory
```ruby
require 'google_subscriber'
GoogleSubscriber.configure do |config|
  config.subscriber_paths += %W( #{Rails.root}/app/subscribers ) 
  config.logger = Rails.logger
  # https://cloud.google.com/docs/authentication/production#auth-cloud-implicit-ruby
  config.google_credentials = '/path/to/cred/file.json' # or File.read('/path/to/cred/file.json')
  config.google_project_id = 'my-gcp-project-id'
end
```
#### Subscribers
1. Add Subscribers to Rails.root/app/subscribers
1. Subscribers should subclass `GoogleSubscriber::BaseSubscriber`

Example:
```ruby
class FooSubscriber < GoogleSubscriber::BaseSubscriber
  subscription_id 'my-subscription-id' # https://cloud.google.com/pubsub/docs/pull#ruby
  subscription_listen_args({ threads: { callback: 16 } }) # https://googleapis.dev/ruby/google-cloud-pubsub/latest/Google/Cloud/PubSub/Subscription.html#listen-instance_method
  
  # optionally override config.google_credentials
  # subscription_credentials '/path/to/cred/file.json' # or File.read('/path/to/cred/file.json')

  # optionally override config.subscription_project_id
  # subscription_project_id 'my-gcp-project-id'
  
  # @param [Class: Google::Cloud::PubSub::ReceivedMessage] received_message The received_message
  def on_received_message(received_message)
    # do something exciting with received_message
    message.acknowledge!
  end
end
```

If the log-level is set to `DEBUG`, log messages such as "the service ws unable to fulfill your request" could show up. It seems
this is an internal transient error. Subsequent retries succeed.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/perryqh/google-subscriber-ruby


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
