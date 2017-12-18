class Weather::Base
  include ApplicationWorker

  def initialize
    raise "please write initialize statement to subclass"
  end
end
