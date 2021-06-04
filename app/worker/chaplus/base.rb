class Chaplus::Base
  include ApplicationWorker

  def initialize
    init("#{Settings.account.chaplus.uri.chat}?apikey=#{env(:chaplus_api_key)}")
  end

  def chat(word)
    raise "keyword is valid format #{word}" if word.blank?

    content = {
      utterance: word,
      agentState: {
        agentName: Settings.account.line.bot_name,
        age: "20歳"
      }
    }

    res = format_response(exec_request(content))
    res
  end

  protected

    def exec_request(content)
      uri = URI.parse(@uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = { "Content-Type" => "application/json" }
      http.post(uri, content.to_json, headers)
    rescue => e
      Rails.logger.error("Failed to connect External Chaplus API url : #{@url}")
      raise e
    end

  def format_response(response)
    if response.code == "200"
      res = JSON.parse(response.body)
      messages = res["responses"].take(5) if res.key?("responses")
      if messages.present?
        messages.sample["utterance"].sub(/\n$/, "")
      else
        "なんて？"
      end
    else
      Rails.logger.error("code : #{response.code}, message : #{response.msg}")
      "さえずるな、愚民が"
    end
  end
end
