require "line/bot"

module LineHelper
  class LineBot
    def initialize(request)
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = Settings.account.line.channel_secret
        config.channel_token  = Settings.account.line.channel_token
      end
      hash = OpenSSL::HMAC.digest(
        OpenSSL::Digest::SHA256.new,
        Settings.account.line.channel_secret,
        request.raw_post
      )
      raise "シグネチャが不正です" unless request.headers["X-LINE-ChannelSignature"] == Base64.strict_encode64(hash)
    end

    def callback(content)
      token   = content["replyToken"]
      message = content["message"]["text"]

      Rails.logger.debug(token)
      Rails.logger.debug(message)

      res = {
        type: "text",
        text: message["text"],
      }
      @client.reply_message(token, res)
    end
  end
end
