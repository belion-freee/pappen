class Sns::Line::Message < Sns::Line::Base
  # if you add method to LineBotModules, you need to add new set to this hash.
  REQUEST_DISTRIBUTOR = {
    google_books:          %w[本 書籍 ブック],
    livedoor_weather:      %w[天気 天候 ウェザー],
    google_place:          %w[地図 所在地 施設 マップ],
    topuru:                %w[とぷる トプル イベント],
    user_register_confirm: %w[ユーザー登録],
  }.freeze

  # POSTBACK = %i[user_register export_event].freeze

  def callback
    # exclude in cases other than group and text
    return if source["type"] != "user" && !reqest_msg["text"].try(:include?, BOT_NAME)
    Rails.logger.info("リクエスト source_type : #{source["type"]}")
    Rails.logger.info("リクエスト reqest_msg_text : #{reqest_msg["text"]}")

    @reqest_msg["text"].try(:delete!, BOT_NAME)

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
        send(method_name.keys.first, msg, uid: source["userId"], gid: source.try(:[], "groupId"))
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
        name = register_user_to_pappen(source["userId"], source["groupId"])
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
end
