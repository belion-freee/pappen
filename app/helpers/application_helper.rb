require "net/http"

module ApplicationHelper
  SUCCESS = Settings.http.success

  def exec_request(method, uri, params: nil)
    case method
    when :get
      res = Net::HTTP.get_response(URI.parse(uri))
    when :post
      res = Net::HTTP.post_form(URI.parse(uri), URI.parse(params))
    end
    raise "HTTP response is not success response_code : #{res.code}" unless res.code == SUCCESS
    res
  rescue => e
    logger.error("Failed to connect External API method: #{method} uri: #{uri} params: #{params}")
    raise e
  end
end
