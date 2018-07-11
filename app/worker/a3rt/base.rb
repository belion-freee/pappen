class A3rt::Base
  include ApplicationWorker

  MESSAGES = {
    %w[ちんちん ちんこ チンコ まんこ マンコ えっち エッチ セックス] => %w[セクハラ、死ね 変態、滅しろ チ◯コ切るぞ？ てめえは殺処分],
    %w[うんこ ウンコ うんち ウンチ クソ くそ] => %w[てめえの存在がうんこだわ お前の口からクソの匂いがする 顔がうんこみたい 存在がうんこ以下 お前喋れるんだ、うんこかと思ったわ],
    %w[つまんね つまんな 退屈] => %w[てめえよりマシ 奇遇だな 貴様の存在がな],
  }.freeze

  def initialize
    init(Settings.account.a3rt.uri.talk, apikey: env(:a3rt_api_key))
  end

  def talk(word)
    raise "keyword is valid format #{word}" if word.blank?

    @params[:query] = word

    ress = MESSAGES.select {|keys, _| keys.any? {|key| word.include?(key) } }

    if ress.present?
      res = ress.values.first
      size = res.size - 1
      res[rand(0..size)]
    else
      format_response(exec_request(:post))
    end
  end

  protected

  def format_response(response)
    res = JSON.parse(response.body)

    if res["status"].zero?
      res["results"].first["reply"]
    else
      Rails.logger.error("message : #{res["message"]}")
      "さえずるな、愚民が"
    end
  end
end
