module HomeHelper
  include ApplicationHelper

  def kousoku_api(f, t, c, sort)
    uri = URI.encode(Settings.uri.kousoku + "f=#{f}&t=#{t}&c=#{c}&sortBy=#{sort}")
    res = exec_request(:get, uri)
    Hash.from_xml(res.body)["Result"]
  end
end
