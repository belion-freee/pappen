class HomeController < ApplicationController
  include HomeHelper

  def index
    @notice = "選択したカテゴリーからランダムで名言をツイートします"
    @res = Settings.maxim.category.invert
  end

  def tweet
    TwitterHelper::Tweet.new.random_tweet(params[:category])
  rescue => e
    @res = e.message
  end

  def line
    logger.info(params)
    LineHelper::Line.new.callback(params)
    head :ok
  rescue => e
    @res = e.message
  end
end
