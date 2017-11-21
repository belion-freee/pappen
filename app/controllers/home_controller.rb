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
    LineHelper::LineBot.new(request, params["events"].first).callback
    head :ok
  rescue => e
    Rails.logger.error(e)
    raise e
  end

  def debug
    reply = { title: "this is debug" }
    # TODO: describe debug code you wanna trace
    render json: reply
  end
end
