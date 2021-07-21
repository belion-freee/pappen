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

    unless Rails.env.development?
      raise "シグネチャが不正です" unless client.validate_signature(request.raw_post, request.headers["X-Line-Signature"])
    end

    @reply_token = content["replyToken"]
    @reqest_msg  = content["message"]
    @source      = content["source"]

    # postback
    if content["postback"].present?
      @reqest_msg = { "type" => "postback", "text" => BOT_NAME.dup, "data" => content["postback"]["data"] }
    end
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

    def register_user_to_pappen(uid, gid, type)
      return if gid.blank? || uid.blank?
      res = (type.to_s == "room") ? get_room_member_profile(gid, uid) : get_group_member_profile(gid, uid)
      name = res["displayName"]
      rm = RoomMember.where(uid: uid, gid: gid).last
      if rm.blank?
        RoomMember.create(uid: uid, gid: gid, name: name)
      elsif rm.name != name
        rm.update(name: name)
      end
      name
    end

    def auto_register_user_to_pappen(uid, gid, type)
      return if gid.blank? || uid.blank?

      rm = RoomMember.where(uid: uid, gid: gid).last
      if rm.blank?
        res = (type.to_s == "room") ? get_room_member_profile(gid, uid) : get_group_member_profile(gid, uid)
        name = res["displayName"]
        RoomMember.create(uid: uid, gid: gid, name: name)
      end
    end

    def leave_bot(gid, type)
      if type == "group"
        client.leave_group(gid)
      else
        client.leave_room(gid)
      end
    end

    def register_line_user(uid)
      return if uid.blank?
      res = get_user_profile(uid)
      name = res["displayName"]
      user = LineUser.where(uid: uid).first
      if user.blank?
        LineUser.create(uid: uid, name: name)
      elsif user.name != name
        user.update(name: name)
      end
      name
    end

  private

    def get_user_profile(uid)
      # pappen could use function get group member profile
      res = client.get_profile(uid)
      raise_error?(uid, res)
      JSON.parse(res.body)
    end

    def get_group_member_profile(gid, uid)
      # pappen could use function get group member profile
      res = client.get_group_member_profile(gid, uid)
      raise_error?(uid, res)
      JSON.parse(res.body)
    end

    def get_room_member_profile(gid, uid)
      # pappen could use function get room member profile
      res = client.get_room_member_profile(gid, uid)
      raise_error?(uid, res)
      JSON.parse(res.body)
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
