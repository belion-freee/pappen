class A3rt::Base
  include ApplicationWorker

  def initialize
    init(Settings.account.a3rt.uri.talk, apikey: env(:a3rt_api_key))
  end

  def talk(word)
    raise "keyword is valid format #{word}" if word.blank?

    @params[:query] = word

    format_response(exec_request(:post))
  end

  protected

  def format_response(response)
    res = JSON.parse(response.body)

    if res["status"].zero?
      res["results"].first["reply"]
    else
      Rails.logger.error("message : #{res["message"]}")
      "その質問には答えられない。。。すまぬ"
    end
  end
end
