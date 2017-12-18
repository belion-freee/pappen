# A module describing the actual processing relating to linebot
# it is necessary to return nil or reply_message's hash
module Sns::Line::LineBot
  def chatting(msg, user_id)
    text = msg.try(:first) || "hello"

    {
      type: "text",
      text: Docomo::Chat.new.chatting(user_id, text),
    }
  end

  def google_books(msg, _)
    res = Google::Book.new.search(msg)

    reply = "検索結果だよ！\n上位の10件を教えるね#{uni(0x100078)}\n\n"

    res.each {|r|
      info = r["volumeInfo"]
      reply << "タイトル : #{info["title"]}\n"
      reply << "著者 : #{info["authors"].join(",")}\n"
      reply << "詳細 : #{info["infoLink"]}\n\n"
    }

    { type: "text", text: reply }
  end

  def livedoor_weather(msg, _)
    city = msg.try(:first) || "東京"

    res = Weather::Livedoor.new.search(city)

    if res.present?
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
    else
      reply = "ごめん！\nその街はわからないから他の都市で検索してね#{uni(0x10007C)}"
    end

    { type: "text", text: reply }
  end

  def google_place(msg, user_id)
    types = msg.try(:first)

    if types.blank?
      return { type: "text", text: "検索したい項目を教えてね#{uni(0x100084)}" }
    end

    info = LastLocationInfo.where(uid: user_id).last

    if info.blank?
      return { type: "text", text: "始めに現在地を教えてね#{uni(0x100084)}" }
    end

    results = Google::Place.new(info.lat, info.lon).search(types)

    if results.present?
      msg = [{ type: "text", text: "近くの#{types}を教えるよ#{uni(0x100084)}" }]

      results.each_with_index {|res, i|
        break if i > 3
        loc = res["geometry"]["location"]
        msg << {
          type:      "location",
          title:     res["name"],
          address:   res["vicinity"],
          latitude:  loc["lat"],
          longitude: loc["lng"],
        }
      }

      msg
    else
      { type: "text", text: "近くに#{types}はないみたい#{uni(0x10007B)}" }
    end
  end

  # def you_tube(msg)
  #   youtube = Google::YouTube.new
  #   res = youtube.search(msg)
  #
  #   reply = [{ type: "text", text: "YouTubeで検索したよ#{uni(0x100084)}" }]
  #
  #   res.each {|r|
  #     reply << {
  #       type:               "video",
  #       originalContentUrl: "#{youtube.video_uri}?v=#{r["id"]["videoId"]}",
  #       previewImageUrl:    r["snippet"]["thumbnails"]["default"]["url"],
  #     }
  #   }
  #   reply_message(reply)
  # end
end
