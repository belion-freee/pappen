require "twitter"

module TwitterHelper
  class Tweet
    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Settings.account.twitter.consumer_key
        config.consumer_secret     = Settings.account.twitter.consumer_secret
        config.access_token        = Settings.account.twitter.access_token
        config.access_token_secret = Settings.account.twitter.access_token_secret
      end
    end

    def random_tweet(category)
      maxims = Maxim.where(category: category)
      maxim = maxims.offset(rand(maxims.count)).first
      tweet = format_tweet(maxim)
      @client.update(tweet)
    end

    private

      def format_tweet(maxim)
        raise "このカテゴリーでの名言が見つかりませんでした！" if maxim.blank?
        tweet = <<-BODY.strip_heredoc
          "#{maxim.remark}"
          - #{maxim.author}
        BODY
        tweet << "出典:#{maxim.source}" if maxim.source.present?
        tweet << maxim.url if maxim.url.present?
        tweet
      end
  end
end
