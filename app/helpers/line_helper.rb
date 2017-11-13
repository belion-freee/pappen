require "line/bot"

module LineHelper
  class Line
    def initialize
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = Settings.account.line.channel_secret
        config.channel_token  = Settings.account.line.channel_token
      end
    end

    def callback(text)
      # line_request = text.
      res = text
      @client.reply_message(event["replyToken"], res)
    end
  end
end
