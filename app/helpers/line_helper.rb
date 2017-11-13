require "line/bot"

module LineHelper
  class LineBot
    def initialize
      Rails.logger.error("ここまできたよ！")
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = Settings.account.line.channel_secret
        config.channel_token  = Settings.account.line.channel_token
      end
    end

    def callback(content)
      # line_request = text.
      Rails.logger.error("ここまできたよ！")
      Rails.logger.error(content)
      Rails.logger.error(content["replyToken"])
      Rails.logger.error(content["message"]["text"])
      res = {
        type: "text",
        text: content["message"]["text"],
      }
      @client.reply_message(content["replyToken"], res)
    end

    def validate_signature?(request)
      signature = request.headers["X-LINE-ChannelSignature"]
      http_request_body = request.raw_post
      hash = OpenSSL::HMAC.digest(
        OpenSSL::Digest::SHA256.new,
        Settings.account.line.channel_secret,
        http_request_body
      )
      signature_answer = Base64.strict_encode64(hash)
      Rails.logger.error("ここまできたよ！")
      Rails.logger.error(signature_answer)
      Rails.logger.error(signature)
      signature == signature_answer
    end
  end
end
