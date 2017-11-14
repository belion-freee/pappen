require "line/bot"

module LineHelper
  class LineBot
    attr_accessor :client, :reply_token, :reqest_msg, :source

    def initialize(request, content)
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = Settings.account.line.channel_secret
        config.channel_token  = Settings.account.line.channel_token
      end

      raise "シグネチャが不正です" unless @client.validate_signature(request.raw_post, request.headers["X-Line-Signature"])

      @reply_token = content["replyToken"]
      @reqest_msg  = content["message"]
      @source      = content["source"]
    end

    def callback
      case reqest_msg["type"]
      when "text"
        return unless valid?
        Rails.logger.info(reqest_msg)
        Rails.logger.info(reqest_msg_a)
        reply_text(reqest_msg_a)
      else
        reply_text("ごめんなさい！\n文字で話しかけてね\0x100013", strict: true)
      end
    end

    private

      def reply_text(msg, strict: false)
        Rails.logger.info(msg)
        msg = ["Hello"] if msg.blank? || !msg.is_a?(Array)
        response = case msg.first
                   when "高速"
                     "ごめんなさい！\n高速はまだ作ってないの\0x100013"
                   when "天気"
                     "ごめんなさい！\n天気はまだ作ってないの\0x100013"
                   else
                     strict ? msg.first : chatting(msg.first)
                   end

        client.reply_message(reply_token, { type: "text", text: response })
      end

      def chatting(msg)
        Rails.logger.info(msg)
        Rails.logger.info(source)
        Rails.logger.info(source["user_id"])
        DocomoHelper::Docomo.new.chatting(source["user_id"], msg)
      end

      def valid?
        if source["type"] == "user"
          true
        elsif reqest_msg_a.first == "ぱっぷん"
          reqest_msg_a.drop(1)
          true
        else
          false
        end
      end

      def reqest_msg_a
        reqest_msg["text"].split(/[[:blank:]]+/)
      end
  end
end
