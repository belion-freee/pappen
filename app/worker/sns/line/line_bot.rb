# A module describing the actual processing relating to linebot
# it is necessary to return nil or reply_message's hash
module Sns::Line::LineBot
  def chat(msg, **opts)
    text = msg.try(:first) || "hello"
    user_id = opts[:uid]

    {
      type: "text",
      text: Docomo::Chat.new.chat(user_id, text),
    }
  end

  def google_books(msg, **opts)
    res = Google::Book.new.search(msg)

    reply = "検索結果だよ！\n上位の5件を教えるね#{uni(0x100078)}\n\n"

    res.each_with_index {|r, i|
      break if i > 4

      info = r["volumeInfo"]
      reply << "タイトル : #{info["title"]}\n"
      reply << "著者 : #{info["authors"].try(:join, ",")}\n"
      reply << "詳細 : #{info["infoLink"]}\n\n"
    }

    { type: "text", text: reply }
  end

  def livedoor_weather(msg, **opts)
    city = msg.try(:first) || "東京"

    res = Weather::LiveDoor.new.search(city)

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

  def google_place(msg, **opts)
    types = msg.try(:first)
    user_id = opts[:uid]

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

  def topuru(msg, **opts)
    types = msg.try(:first)
    gid = opts[:gid]

    if types.blank?
      events = Event.where(gid: gid)

      res = [get_group_member_profile(gid)]

      res << events.blank? ?
        {
          type:     :template,
          altText:  :confirm,
          template: {
            type:    :confirm,
            text:    "まだイベントが登録されてないよ！\nイベントを新しく作る？#{uni(0x10007F)}",
            actions: [
              {
                type:  :uri,
                label: "はい",
                uri:   Settings.account.topuru.uri.create % gid,
              },
            ],
          },
        } :
        {
          type:     :template,
          altText:  "イベントを選んでね！#{uni(0x100079)}",
          template: {
            type:    :carousel,
            columns: events.map {|ev|
                       {
                         text:    ev.name,
                         actions: [
                           {
                             type:  :uri,
                             label: "詳細",
                             uri:   Settings.account.topuru.uri.create % ev.id,
                           },
                           {
                             type:  :postback,
                             label: "お会計",
                             data:  "export&event_id=#{ev.id}",
                           },
                         ],
                       }
                     },
          },
        }
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
