require "line/bot"

module LineHelper
  class LineBot
    BOT_NAME = Settings.account.line.bot_name

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
        reply_text(reqest_msg["text"].split(/[[:blank:]]+/).reject(&:blank?))
      else
        reply_text("ごめんなさい！\n文字で話しかけてね\0x100013", strict: true)
      end
    end

    private

      def reply_text(msg, strict: false)
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
        DocomoHelper::Docomo.new.chatting(source["userId"], msg)
      end

      def valid?
        if source["type"] == "user"
          true
        elsif reqest_msg["text"].include?(BOT_NAME)
          reqest_msg["text"].delete(BOT_NAME)
          true
        else
          false
        end
      end
  end
end
