class Sns::Line::Message < Sns::Line::Base
  # if you add method to LineBotModules, you need to add new set to this hash.
  REQUEST_DISTRIBUTOR = {
    google_books:     %w[本 書籍 ブック],
    livedoor_weather: %w[天気 天候 ウェザー],
    google_place:     %w[地図 所在地 施設 マップ],
    topuru:           %w[とぷる トプル イベント],
    user_register:    %w[@],
  }.freeze

  def callback
    # exclude in cases other than group and text
    return if source["type"] != "user" && !reqest_msg["text"].try(:include?, BOT_NAME)

    @reqest_msg["text"].try(:delete!, BOT_NAME)

    # distribute methods by type
    method_name = "request_type_#{reqest_msg["type"]}"
    res = self.respond_to?(method_name, true) ?
      send(method_name) :
      { type: :text, text: "処理できな-い#{uni(0x10009D)}" }

    if res.present?
      if res.is_a?(Array)
        Rails.logger.info("in Array")
        res.each_with_index {|content, i|
          Rails.logger.info("content is #{content}")
          if content.is_a?(Proc)
            Rails.logger.info("content is in proc #{content}")
            content.()
            res.delete_at(i)
          end
          Rails.logger.info("content is outer proc #{res}")
        }
      end
      Rails.logger.info("res is #{res}")
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
end
