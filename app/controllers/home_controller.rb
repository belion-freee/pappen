class HomeController < ApplicationController
  protect_from_forgery except: [:line]

  def index; end

  def line
    Sns::Line::Message.new(request, params["events"].first).callback
    render json: :ok
  rescue StandardError => e
    Rails.logger.error(e)
    render status: 500, json: :bad
  end

  def debug
    # TODO: describe debug code you wanna trace
    content = {
      replyToken: :reply_token,
      message: {
        text: "ふるさと納税",
        type: :text,
      },
      source: {
        type: :user
      },
    }.deep_stringify_keys
    res = Sns::Line::Message.new(request, content).callback
    reply = { data: res }
    render json: reply
  end
end
