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
    @res = e.message
  end

  def line
    logger.error("ここまできたよ！")
    line = LineHelper::Line.new
    logger.error("ここまできたよ！")
    head :bad_request unless line.validate_signature?(request)
    logger.error("ここまできたよ！")
    logger.error(params["events"])
    logger.error(params["events"].first)
    res = line.callback(params["events"].first)
    logger.error(res)
    head :ok
  rescue => e
    raise e
  end
end
