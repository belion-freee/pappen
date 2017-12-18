class Weather::LiveDoor < Weather::Base
  CITYS = WeatherSettings[:city]

  def initialize
    init(Settings.account.livedoor.weather.uri)
  end

  def search(word)
    raise "keyword is valid format #{word}" if word.blank?

    id = CITYS.key(word)
    unless id
      Rails.logger.info("city is NOT FOUND params is #{word}")
      return nil
    end

    @params[:city] = id

    JSON.parse(
      exec_request(:get)
    )
  end
end
