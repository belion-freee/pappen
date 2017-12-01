module WeatherHelper
  class Livedoor
    include ApplicationHelper

    API_URI = Settings.account.livedoor.weather.uri
    CITYS = Settings.weather[:city]

    attr_accessor :params

    def initialize
      @params = ""
    end

    def search(word)
      raise "keyword is valid format #{word}" if word.blank?

      id = CITYS.key(word)
      unless id
        Rails.logger.info("city is NOT FOUND params is #{word}")
        return nil
      end

      @params << "city=#{id}"
      res = exec_request(:get, API_URI, *params)
      JSON.parse(res)
    end
  end
end
