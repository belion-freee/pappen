class HousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house, only: %i[show update]
  before_action :member?, only: %i[show update]

  def show
    @members = RoomMember.names(@house.room_members.first.gid)
    @house_expenditures = HouseExpenditure.search(@house.id, target_date)
    @monthly_summary = HouseExpenditure.monthly_summary(@house.id, target_date)
    @groups = @house_expenditures.group_by(&:category)
    accounting = HouseExpenditure.accounting(@house_expenditures, @house.room_members)
    @accountings = {
      total: @house_expenditures.map(&:payment).inject(:+),
      bill:  accounting,
    }
    @house_bill = @house.house_bills.find_or_create_by(entry_date: target_date)
  end

  def update
    if @house.update(permitted_params)
      render json: :ok
    else
      render json: { errors: @house.errors.full_messages }, status: :bad_request
    end
  end

  def bill
    blog = HouseBill.find_by(house_id: params[:house_id], entry_date: target_date)
    blog.update!(done: ActiveRecord::Type::Boolean.new.cast(params[:done]), user_id: current_user.id)
    render json: { done: blog.done }
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

    def member?
      room_members = House.find_by(hid: params[:id])&.room_members || []
      members = RoomMember.where(uid: current_user.line_user&.uid)
      head :unauthorized if (room_members & members).blank?
    end
end
