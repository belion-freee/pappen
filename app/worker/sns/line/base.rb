require "line/bot"

class Sns::Line::Base
  include ApplicationWorker
  include LineBot

  BOT_NAME = Settings.account.line.bot_name

  def initialize(request, content)
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = env(:line_channel_secret)
      config.channel_token  = env(:line_channel_token)
    end

    raise "シグネチャが不正です" unless client.validate_signature(request.raw_post, request.headers["X-Line-Signature"])

    @reply_token = content["replyToken"]
    @reqest_msg  = content["message"]
    @source      = content["source"]
  end

  protected

    def reply_token
      raise "reply_token is not defined" if @reply_token.blank?
      @reply_token
    end

    def reqest_msg
      raise "reqest_msg is not defined" if @reqest_msg.blank?
      @reqest_msg
    end

    def source
      raise "source is not defined" if @source.blank?
      @source
    end

    def reply_message(msg)
      res = client.reply_message(reply_token, msg)

      unless res.present? && res.code == SUCCESS
        raise <<~ERROR
          \nLine API returned Error.
          request params : #{reqest_msg}
          response code : #{res.try(:code)}
          response body : #{res.try(:body)}
        ERROR
      end
    end

    def get_group_member_profile(gid)
      res = client.get_group_member_ids(gid, reply_token)
      unless res.present? && res.code == SUCCESS
        raise <<~ERROR
          \nLine API returned Error.
          request params : #{gid}
          response code : #{res.try(:code)}
          response body : #{res.try(:body)}
        ERROR
      end
    end
end
