class Google::Place < Google::Base
  def initialize(lat, lon)
    init(
      :place_search,
      language: :ja,
      key:      env(:google_api_key),
      rankby:   :distance,
      location: "#{lat},#{lon}"
    )
  end

  def search(q)
    raise "required params keyword is blank!" if q.blank?

    @params[:keyword] = q

    format_response(
      exec_request(:get),
      "results"
    )
  end
end
