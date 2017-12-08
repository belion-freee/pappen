require "line/bot"

module LineHelper
  include ApplicationHelper

  class LineBot
    include LineHelper

    BOT_NAME = Settings.account.line.bot_name

    attr_accessor :client, :reply_token, :reqest_msg, :source

    def initialize(request, content)
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = env(:line_channel_secret)
        config.channel_token  = env(:line_channel_token)
      end

      raise "シグネチャが不正です" unless @client.validate_signature(request.raw_post, request.headers["X-Line-Signature"])

      @reply_token = content["replyToken"]
      @reqest_msg  = content["message"]
      @source      = content["source"]
    end

    def callback
      return unless valid?
      case reqest_msg["type"]
      when "text"
        reply_text(*reqest_msg["text"].split(/[[:blank:]]+/).reject(&:blank?))
      when "sticker"
        reply_sticker
      else
        reply_text("文字で話しかけてね#{uni(0x10009D)}", strict: true)
      end
    end

    private

      def reply_text(*msg, strict: false)
        Rails.logger.info("Bot名をのぞいたリクエストメッセージ : #{msg}")
        msg = ["Hello"] if msg.blank?
        response = case msg.first
                   when "本", "図書", "書籍"
                     msg.slice!(0)
                     google_books(msg)
                   when "天気"
                     msg.slice!(0)
                     livedoor_weather(msg.first)
                   else
                     strict ? msg.first : chatting(msg.first)
                   end
        client.reply_message(reply_token, { type: "text", text: response })
      end

      def reply_sticker
        pkid = rand(1..2)
        stid = pkid == 1 ? rand(100..139) : rand(140..179)

        Rails.logger.info("レスポンスのスタンプ packageId : #{pkid}, stickerId : #{stid}")

        client.reply_message(
          reply_token,
          {
            type:      "sticker",
            packageId: pkid,
            stickerId: stid,
          }
        )
      end

      def chatting(msg)
        DocomoHelper::Docomo.new.chatting(source["userId"], msg)
      end

      def google_books(msg)
        res = GoogleHelper::Book.new.search(msg)

        reply = "検索結果だよ！\n上位の10件を教えるね#{uni(0x100078)}\n\n"

        res.each {|r|
          info = r["volumeInfo"]
          reply << "タイトル : #{info["title"]}\n"
          reply << "著者 : #{info["authors"].join(",")}\n"
          reply << "詳細 : #{info["infoLink"]}\n\n"
        }
        reply
      end

      def livedoor_weather(msg)
        res = WeatherHelper::Livedoor.new.search(msg)

        if res.blank?
          return "ごめん！\nその街はわからないから他の都市で検索してね#{uni(0x10007C)}"
        end

        reply = "#{res["title"]}を教えるね#{uni(0x10007F)}\n\n"

        res["forecasts"].each {|r|
          reply << "#{r["dateLabel"]}のお天気は#{r["telop"]}！\n"

          min = r["temperature"]["min"].blank? ? "ちょうどいい温" : r["temperature"]["min"]["celsius"]
          max = r["temperature"]["max"].blank? ? "そこそこの温" : r["temperature"]["max"]["celsius"]
          reply << "気温はね、最高が#{max}度で、最低は#{min}度だよ！\n\n"
        }

        if res["description"]["text"].present?
          reply << "詳細な説明だよ#{uni(0x1000B1)}\n"
          reply << res["description"]["text"]
        end
        reply
      end

      def valid?
        if source["type"] == "user"
          true
        elsif reqest_msg["type"] == "text" && reqest_msg["text"].include?(BOT_NAME)
          reqest_msg["text"].delete!(BOT_NAME)
          true
        else
          false
        end
      end
  end
end
