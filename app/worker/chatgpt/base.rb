class Chatgpt::Base
  include ApplicationWorker

  def initialize
    init(Settings.account.chatgpt.uri.talk, apikey: env(:chatgpt_api_key))
  end

  def chat(word)
    raise "keyword is valid format #{word}" if word.blank?

    body = {
      model: "text-davinci-003",
      prompt: word,
      max_tokens: 4000
    }

    uri = URI.parse(@uri)

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = "application/json"
    req['Authorization'] = "Bearer #{@params[:apikey]}"
    req.body = body.to_json
    res = http.request(req)

    format_response(res)
  end

  protected

  def format_response(response)
    res = JSON.parse(response.body)

    if res["error"].blank?
      res["choices"].map {|choice| choice["text"] }
    else
      ["Error : #{res["error"]["message"]}"]
    end
  end
end
