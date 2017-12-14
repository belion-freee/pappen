module GoogleHelper
  include ApplicationHelper

  attr_accessor :uri, :params

  class Book
    include GoogleHelper

    MAX_ITEMS = 10

    def initialize
      @params = [
        "country=JP",
      ]
      @uri = Settings.account.google.books.uri
    end

    def search(word)
      raise "keyword is valid format #{word}" if word.blank?
      word = word.join("+") if word.is_a?(Array)
      @params << "q=#{word}"
      res = exec_request(:get, uri, *params)
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

    def initialize(lat, lon)
      @params = [
        "key=#{env(:google_api_key)}",
        "rankby=distance",
        "location=#{lat},#{lon}",
      ]
      @uri = Settings.account.google.place.uri
    end

    def search(q)
      raise "required params keyword is blank!" if q.blank?

      @params.push("keyword=#{q}")

      res = exec_request(:get, uri, *params)
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

  class YouTube
    include GoogleHelper

    attr_accessor :video_uri

    MAX_ITEMS = 3

    def initialize
      @params = [
        "key=#{env(:google_api_key)}",
        "part=snippet",
        "regionCode=JP",
        "type=video",
        "maxResults=#{MAX_ITEMS}",
      ]
      @uri = Settings.account.google.youtube.search_uri
      @video_uri = Settings.account.google.youtube.video_uri
    end

    def search(q)
      raise "searce keyword is blank" if q.blank?

      q = q.join("+") if q.is_a?(Array)

      @params.push("q=#{q}")

      res = exec_request(:get, uri, *params)

      format_response(res)
    end

    private

      def format_response(res_json)
        res = JSON.parse(res_json)

        if res["error"].present?
          Rails.logger.error(
            <<~ERROR
              YouTube API returned Error.
              request params   : #{params}
              response code    : #{res["error"].try(:fetch, "code")}
              response message : #{res["error"].try(:fetch, "message")}
            ERROR
          )
          return nil
        end

        if res["items"].blank?
          Rails.logger.info("YouTube serch result is NOT FOUND params : #{params}")
          return nil
        end
        res["items"]
      end
  end
end
