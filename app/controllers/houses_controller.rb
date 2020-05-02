class HousesController < ApplicationController
  before_action :set_house, only: %i[show update]

  def show
    @members = RoomMember.names(@house.room_members.first.gid)
    @house_expenditures = HouseExpenditure.search(@house.id, target_date)
    @monthly_summary = HouseExpenditure.monthly_summary(@house.id)
    @groups = @house_expenditures.group_by(&:category)
    accounting = HouseExpenditure.accounting(@house_expenditures, @house.room_members)
    @accountings = {
      total: @house_expenditures.map(&:payment).inject(:+),
      bill:  accounting,
    }
  end

  def update
    if @house.update(permitted_params)
      render json: :ok
    else
      render json: { errors: @house.errors.full_messages }, status: :bad_request
    end
  end

  private

    def target_date
      params[:date].present? ? Time.new(params[:date][0..3], params[:date][4..5]) : Time.now.beginning_of_month
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_house
      @house = House.includes(:room_members).includes(:house_expenditures).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:house).permit(:name, :memo, room_member_ids: [])
    end
end
