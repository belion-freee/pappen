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
      raise_error?(msg, client.reply_message(reply_token, msg))
    end

    def register_user_to_pappen(uid, gid = nil)
      gid = nil if gid.blank?
      res = get_user_profile(uid)
      RoomMember.create(uid: uid, gid: gid, name: res["displayName"]) if RoomMember.where(uid: uid, gid: gid).blank?
    end

  private

    def get_user_profile(uid)
      res = client.get_profile(uid)
      raise_error?(uid, res)
      res.body
    end

    def raise_error?(param, res)
      raise_error(param: param, code: res.try(:code), body: res.try(:body)) unless res.try(:code) == SUCCESS
    end

    def raise_error(**errors)
      raise <<~ERROR
        Line API returned Error.
        request params : #{errors[:param]}
        response code  : #{errors[:code].try(:force_encoding, "utf-8")}
        response body  : #{errors[:body].try(:force_encoding, "utf-8")}
      ERROR
    end
end
