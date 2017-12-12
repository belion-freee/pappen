module GoogleHelper
  include ApplicationHelper

  class Book
    include GoogleHelper

    API_URI = Settings.account.google.books.uri
    MAX_ITEMS = 10

    attr_accessor :params

    def initialize
      @params = ["country=JP"]
    end

    def search(word)
      raise "keyword is valid format #{word}" if word.blank?
      word = word.join("+") if word.is_a?(Array)
      @params << "q=#{word}"
      res = exec_request(:get, API_URI, *params)
      format_response(res)
    end

    private

      def format_response(res_json)
        res = JSON.parse(res_json)
        unless res.try(:fetch, "items")
          Rails.logger.info("Google books serch result is NOT FOUND params is #{params}")
          return nil
        end
        res["items"][0, MAX_ITEMS]
      end
  end

  class Place
    include GoogleHelper

    API_URI = Settings.account.google.place.uri
    TYPES = "cafe".freeze

    attr_accessor :params

    def initialize(lat, lon)
      @params = [
        "language=ja",
        "key=#{env(:google_api_key)}",
        "rankby=distance",
        "location=#{lat},#{lon}",
      ]
    end

    def search(types)
      types ||= TYPES

      @params.push("types=#{types}")

      res = exec_request(:get, API_URI, *params)
      format_response(res)
    end

    private

      def format_response(res_json)
        res = JSON.parse(res_json)
        unless res.try(:fetch, "results").try(:present?)
          Rails.logger.info("Google place serch result is NOT FOUND params is #{params}")
          return nil
        end
        res["results"]
      end
  end
end
