class Sns::Line::Message < Sns::Line::Base
  # if you add method to LineBotModules, you need to add new set to this hash.
  REQUEST_DISTRIBUTOR = {
    topuru:                %w[トプル イベント],
    house:                 %w[家計簿],
    user_register_confirm: %w[ユーザー登録],
    user_event:            %w[マイイベント],
    event_title:           %w[イベントタイトル],
    expenditure:           %w[経費申請],
    expenditure_confirm:   %w[収支確認],
    leave:                 %w[もう大丈夫だよ],
    help:                  %w[ヘルプ],
  }.freeze

  # POSTBACK = %i[user_register export_event].freeze

  def callback
    if %w(group room).include?(source["type"].to_s)
      # auto register room member
      auto_register_user_to_pappen(source["userId"], group_id, source["type"])

      # exclude without text BOT_NAME
      return if !reqest_msg["text"].try(:include?, BOT_NAME)
    end

    @reqest_msg["text"].try(:slice!, BOT_NAME)

    # distribute methods by type
    method_name = "request_type_#{reqest_msg["type"]}"
    res = self.respond_to?(method_name, true) ?
      send(method_name) :
      { type: :text, text: "処理できな-い#{uni(0x10009D)}" }

    if res.present?
      if res.is_a?(Array)
        res.each_with_index {|content, i|
          if content.is_a?(Proc)
            content.()
            res.delete_at(i)
          end
        }
      end
      reply_message(res)
    else
      Rails.logger.info("line reply had not send")
    end
  end

  protected

    def request_type_text
      # become message to array
      msg = reqest_msg["text"].split(/[[:blank:]]+/).reject(&:blank?)

      # select method_name matching keyword
      method_name = REQUEST_DISTRIBUTOR.select {|_, v| v.include?(msg.first) }

      if method_name.present?
        # remove REQUEST_DISTRIBUTOR
        msg.delete_at(0)
        send(method_name.keys.first, msg, uid: source["userId"], gid: group_id, type: source["type"])
      else
        chat(msg, uid: source["userId"])
      end
    end

    def request_type_sticker
      pkid = rand(1..2)
      stid = pkid == 1 ? rand(100..139) : rand(140..179)

      Rails.logger.info("レスポンスのスタンプ packageId : #{pkid}, stickerId : #{stid}")

      {
        type:      "sticker",
        packageId: pkid,
        stickerId: stid,
      }
    end

    def request_type_location
      lat, lon = reqest_msg["latitude"], reqest_msg["longitude"]

      info = LastLocationInfo.where(uid: source["userId"]).last

      if info.blank?
        info = LastLocationInfo.new(uid: source["userId"], lat: lat, lon: lon)
      else
        info.lat = lat
        info.lon = lon
      end

      info.save!
      { type: "text", text: "現在地を登録したよ#{uni(0x100084)}" }
    end

    def request_type_postback
      data = reqest_msg["data"].split("&")

      case data.first.try(:to_sym)
      when :user_register
        name = group_id.blank? ? register_line_user(source["userId"]) : register_user_to_pappen(source["userId"], group_id, source["type"])
        { type: "text", text: "#{name} をユーザ登録したよ#{uni(0x100079)}" }
      when :room_members
        event = Event.find(data[1])
        members = event.room_members.map {|rm| "- #{rm.name}" }

        body = "イベント : #{event.name}\n"
        body << "参加者数 : #{members.size}人\n"
        body << "参加メンバー\n"
        body << members.join("\n")

        { type: "text", text: body }
      else
        raise "it is unkown postback #{data.first}"
      end
    end

    private

      def group_id
        source["groupId"] || source["roomId"]
      end
end
