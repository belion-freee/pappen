class Google::YouTube < Google::Base
  def initialize
    init(
      :youtube_search,
      part:       :snippet,
      regionCode: :JP,
      key:        env(:google_api_key),
      type:       :video,
      maxResults: 5
    )
  end

  def search(q)
    raise "searce keyword is blank" if q.blank?

    @params[:q] = concat(q)

    format_response(
      exec_request(:get),
      "items"
    )
  end
end
