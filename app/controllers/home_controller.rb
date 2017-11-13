class HomeController < ApplicationController
  include HomeHelper

  protect_from_forgery except: [:line]

  def index
    @notice = "選択したカテゴリーからランダムで名言をツイートします"
    @res = Settings.maxim.category.invert
  end

  def tweet
    TwitterHelper::Tweet.new.random_tweet(params[:category])
  rescue => e
    Rails.logger.error(e)
    @res = e.message
  end

  def line
    LineHelper::LineBot.new(request).callback(params["events"].first)
    head :ok
  rescue => e
    Rails.logger.error(e)
    raise e
  end
end
