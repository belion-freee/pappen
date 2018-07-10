require "net/http"

module ApplicationWorker
  SUCCESS = Settings.http.success

  protected

    def init(uri, **params)
      @uri    = uri
      @params = params
    end

    def exec_request(method)
      case method
      when :get
        res = Net::HTTP.get(URI.parse(create_get_request))
      when :post
        res = Net::HTTP.post_form(URI.parse(uri), params)
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

    def uni(uni)
      raise "unicode is invalid : #{uni}" unless uni.present? && uni.is_a?(Integer)
      uni.chr(Encoding::UTF_8)
    end

    def concat(*words)
      raise "words is invalid : #{words}" if words.blank?
      words.join("+")
    end

    def uri
      raise "uri is invalid : #{@uri}" unless @uri.present? && @uri.is_a?(String)
      @uri
    end

    def params
      raise "params is invalid : #{@params}" unless @params.present? && @params.is_a?(Hash)
      @params
    end

    def client
      raise "client is not initialized : #{@client}" if @client.blank?
      @client
    end

  private

    def create_get_request
      uri_params = params.map {|k, v| "#{k}=#{v}" }.join("&")
      URI.escape("#{uri}?#{uri_params}")
    end
end
