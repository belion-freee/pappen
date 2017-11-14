require "line/bot"

module LineHelper
  class LineBot
    def initialize(request)
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = Settings.account.line.channel_secret
        config.channel_token  = Settings.account.line.channel_token
      end
      Rails.logger.info(request)
      Rails.logger.info(request.headers)
      Rails.logger.info(request.headers["X-LINE-ChannelSignature"])
      Rails.logger.info(request.raw_post)
      raise "シグネチャが不正です" unless @client.validate_signature(request.raw_post, request.headers["X-LINE-ChannelSignature"])
    end

    def callback(content)
      token   = content["replyToken"]
      message = content["message"]["text"]

      Rails.logger.info(token)
      Rails.logger.info(message)

      res = {
        type: "text",
        text: message["text"],
      }
      @client.reply_message(token, res)
    end
  end
end
