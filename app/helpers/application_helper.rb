require "net/http"

module ApplicationHelper
  SUCCESS = Settings.http.success

  def exec_request(method, uri, *params)
    case method
    when :get
      res = Net::HTTP.get(URI.parse(format_get_request(uri, params)))
    when :post
      res = Net::HTTP.post_form(URI.parse(uri), URI.parse(params))
    end
    raise "HTTP response is not success response_code" if res.blank?
    res
  rescue => e
    Rails.logger.error("Failed to connect External API method: #{method} uri: #{uri} params: #{params}")
    raise e
  end

  def env(sym)
    raise "symbol is blank at env" if sym.blank?
    ENV[sym.to_s.upcase]
  end

  protected

    def format_get_request(uri, params)
      raise "uri and params invalid format" unless uri.is_a?(String) && params.is_a?(Array)
      URI.escape("#{uri}?#{params.join("&")}")
    end
end
