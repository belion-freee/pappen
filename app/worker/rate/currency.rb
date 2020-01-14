class Rate::Currency
  include ApplicationWorker

  AVAILABLE_RATES = %w(CAD HKD ISK PHP DKK HUF CZK GBP RON SEK IDR INR BRL RUB HRK JPY THB CHF EUR MYR BGN TRY CNY NOK NZD ZAR USD MXN SGD AUD ILS KRW PLN).freeze

  def initialize
    init(Settings.account.exchangerates.uri)
  end

  def latest(currency = "JPY")
    rate_map = { "JPY" => 1 }
    return rate_map if currency == "JPY"

    raise "currency #{currency} is not available" unless AVAILABLE_RATES.include?(currency)

    @params[:base] = currency

    begin
      rates = JSON.parse(exec_request(:get))["rates"]

      return rate_map if ["rates"].blank?

      rates.map {|k, v|
        [k, v.to_f]
      }.to_h
    rescue => e
      Rails.logger.error(e)
      Rails.logger.error("Failed but skip error and return origin money")
      rate_map
    end
  end
end
