class HomeController < ApplicationController
  include HomeHelper

  def index
    debugger
    @notice = "選択したカテゴリーからランダムで名言をツイートします"
    @res = Settings.maxim.category.invert
  end

  def tweet
    TwitterHelper::Tweet.new.random_tweet(params[:category])
  rescue => e
    @res = e.message
  end

  def line
    line = LineHelper::Line.new
    head :bad_request unless line.validate_signature?(request)
    line.callback(params[:events].first)
    head :ok
  rescue => e
    @res = e.message
  end
end
