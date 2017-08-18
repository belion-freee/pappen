class HomeController < ApplicationController
  include HomeHelper

  def index
    @res = {
      prefectures: Settings.prefectures,
      vehicle:     Settings.vehicle,
      sort:        Settings.sort,
    }
  end

  def show
    from = params[:from]
    to = params[:to]
    vehicle = params[:vehicle] ||= "普通車"
    sort = params[:sort] ||= "距離"
    res = kousoku_api(from, to, vehicle, sort)
    return if res.key?("NotFound")
    @cond = [
      { name: "出発IC", val: res["From"] },
      { name: "到着IC", val: res["To"] },
      { name: "自動車", val: res["CarType"] },
      { name: "ソート条件(昇順)", val: res["SortBy"] },
    ]
    @res = res["Routes"]["Route"]
  end

  def options
    render json: InterChange.where(prefectures: params["name"]).map(&:ic)
  end
end
