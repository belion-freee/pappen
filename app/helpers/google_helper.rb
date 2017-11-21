module GoogleHelper
  class Book
    include ApplicationHelper

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
          logger.info("Google books serch result is NOT FOUND params is #{params}")
          return nil
        end
        res["items"][0, MAX_ITEMS]
      end
  end
end
