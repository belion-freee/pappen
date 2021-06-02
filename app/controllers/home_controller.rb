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
    reply = { title: "this is debug" }
    # TODO: describe debug code you wanna trace
    render json: reply
  end
end
