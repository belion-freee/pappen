require "twitter"

class Sns::Twitter::Base
  include ApplicationWorker

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = env(:twitter_consumer_key)
      config.consumer_secret     = env(:twitter_consumer_secret)
      config.access_token        = env(:twitter_access_token)
      config.access_token_secret = env(:twitter_access_token_secret)
    end
  end
end
