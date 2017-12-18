class Google::Base
  include ApplicationWorker

  attr_accessor :uri, :params

  def initialize
    raise "please write initialize statement to subclass"
  end

  protected

    def init(sym, **params)
      uri = Settings.account.google.uri[sym]
      super(uri, **params)
    end

    def format_response(res_json, key)
      res = JSON.parse(res_json)

      if res["error"].present?
        raise <<~ERROR
          \nGoogle API returned Error.
          request params   : #{params}
          response code    : #{res["error"].try(:fetch, "code")}
          response message : #{res["error"].try(:fetch, "message")}
        ERROR
      end

      if res[key].blank?
        Rails.logger.info("Result is NOT FOUND. params : #{params}")
        return nil
      end

      res[key]
    end
end
