require "docomoru"

class Docomo::Base
  include ApplicationWorker

  def initialize
    @client = Docomoru::Client.new(api_key: env(:docomo_api_key))
  end
end
