class Google::Book < Google::Base
  def initialize
    init(
      :book_search,
      country: :JP
    )
  end

  def search(word)
    raise "keyword is valid format #{word}" if word.blank?

    @params[:q] = concat(word)

    format_response(
      exec_request(:get),
      "items"
    )
  end
end
