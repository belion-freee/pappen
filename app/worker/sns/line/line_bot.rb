# A module describing the actual processing relating to linebot
# it is necessary to return nil or reply_message's hash
module Sns::Line::LineBot
  def chat(msg, **opts)
    text = msg.try(:first) || "hello"

    {
      type: "text",
      text: A3rt::Base.new.talk(text),
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
    gid = opts[:gid]

    return { type: "text", text: "イベントはグループでしか作れないよ！" } if gid.blank?

    members = RoomMember.where(gid: gid)

    return { type: "text", text: "メンバー登録を先にしてね！" } if members.blank?

    events = Event.selected_gid(gid)

    if events.blank? || msg.include?("作成")
      event_name = (msg.size > 1) ? msg[1] : dummy_name
      event = Event.new(name: event_name, room_members: members)

      if event.save
        {
          type:     :template,
          altText:  "イベントだよ！",
          template: {
            type:    :carousel,
            columns: [
              {
                text:    "イベント",
                actions: [
                  {
                    type:  :uri,
                    label: event.name,
                    uri:   Settings.account.topuru.uri % event.id,
                  },
                ],
              },
            ],
          },
        }
      else
        { type: "text", text: event.errors.full_messages.unshift("登録に失敗しました。").join("\n") }
      end

    else
      events_carousel(events)
    end
  end

  def house(msg, **opts)
    gid = opts[:gid]

    return { type: "text", text: "家計簿はグループでしか作れないよ！" } if gid.blank?

    members = RoomMember.where(gid: gid)

    return { type: "text", text: "メンバー登録を先にしてね！" } if members.blank?

    house = House.selected_gid(gid)

    if house.blank?
      house = House.new(name: dummy_name, memo: "This is subtitle!", room_members: members)
      house.save!
    end

    {
      type:     :template,
      altText:  "家計簿だよ！",
      template: {
        type:    :carousel,
        columns: [
          {
            text:    "家計簿",
            actions: [
              {
                type:  :uri,
                label: house.name,
                uri:   Settings.account.house.uri % house.id,
              },
            ],
          },
        ],
      },
    }
  end

  def expenditure(_, **opts)
    uid = opts[:uid]

    return { type: "text", text: "グループ内で経費申請はできないよ！" } if opts[:gid].present?

    id = LineUser.where(uid: uid).first.try(:id)

    return { type: "text", text: "ユーザー登録を先にしてね！" } if id.blank?

    {
      type:     :template,
      altText:  "経費申請だよ！",
      template: {
        type:    :carousel,
        columns: [
          {
            text:    "経費申請の項目だよ",
            actions: [
              {
                type:  :uri,
                label: "収支確認",
                uri:   Settings.account.expenditure.uri % id,
              },
            ],
          },
        ],
      },
    }
  end

  def expenditure_confirm(_, **opts)
    uid = opts[:uid]

    return { type: "text", text: "グループ内で経費確認はできないよ！" } if opts[:gid].present?

    id = LineUser.where(uid: uid).first.try(:id)

    return { type: "text", text: "ユーザー登録を先にしてね！" } if id.blank?

    res = Expenditure.search({
      line_user_id: id,
      from_date:    Time.zone.today.beginning_of_month,
      to_date:      Time.zone.today.end_of_month,
    })

    body = "今月の収支状況だよ#{uni(0x100096)}\n"
    body << "総支出額 : #{res.sum(:payment).to_s(:delimited)}円\n"
    body << res.summary.map {|k, v| "- #{k}: #{v.to_s(:delimited)}円" }.join("\n")

    { type: "text", text: body }
  end

  def user_register_confirm(_, _)
    {
      type:     "template",
      altText:  "ユーザー登録だよ！",
      template: {
        type:    "confirm",
        text:    "ユーザー登録する？",
        actions: [
          {
            type:  :postback,
            label: "はい!",
            data:  :user_register,
          },
          {
            type:  :message,
            label: "いいえ!",
            text:  "ユーザー登録しませんでした！",
          },
        ],
      },
    }
  end

  def user_event(msg, **opts)
    events = Event.includes(:room_members).where(room_members: { uid: opts[:uid] })

    events.blank? ? { type: "text", text: "あなたのイベントがないね〜" } : events_carousel(events)
  end

  def event_title(msg, **opts)
    name = msg.try(:first)
    return { type: "text", text: "イベントタイトルを教えなさい" } if name.blank?

    events = Event.includes(:room_members).where(room_members: { uid: opts[:uid] }).select {|ev| ev.name.include?(name) }

    events.blank? ? { type: "text", text: "指定した名前のイベントはないね〜" } : events_carousel(events)
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

  def help(_, _)
    {
      type: "text",
      text: "私の使い方を教えるね#{uni(0x10008D)}\n下のリンクから確認してね！\nhttps://github.com/belion-freee/pappen/blob/master/README.md",
    }
  end

  def leave(_, **opts)
    reply = {
      type: "text",
      text: "お仕えできて光栄でした\nノブレス・オブリージュ 今後も救世主たらんことを",
    }
    reply_message([reply])

    leave_bot(opts[:gid], opts[:type])
  end

  private

    def events_carousel(events)
      {
        type:     :template,
        altText:  "イベントを選んでね！",
        template: {
          type:    :carousel,
          columns: events.map {|ev|
                     {
                       text:    ev.name,
                       actions: [
                         {
                           type:  :uri,
                           label: "詳細",
                           uri:   Settings.account.topuru.uri % ev.id,
                         },
                         {
                           type:  :postback,
                           label: "参加メンバー",
                           data:  "room_members&#{ev.id}",
                         },
                       ],
                     }
                   },
        },
      }
    end

    def dummy_name
      "dummy#{Time.new.strftime("%Y%m%d%H%M%S")}"
    end
end
