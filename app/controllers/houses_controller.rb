class HousesController < ApplicationController
  before_action :set_house, only: %i[show update]

  def show
    @members = RoomMember.where(gid: @house.room_members.first.gid)
    # @expenses = Expense.where(house_id: params[:id])
    # @total = @expenses.map {|ex| ex[:payment] }.inject(:+) || 0
    # @accountings = create_accountings
  end

  def update
    debugger
    if @house.update(permitted_params)
      render json: :ok
    else
      render json: { errors: @house.errors.full_messages }, status: :bad_request
    end
  end

  # POST /paid
  def paid
    rme = RoomMemberHouse.where(house_id: params[:house_id], room_member_id: params[:room_member_id]).last
    rme.update(paid: params[:paid]) if rme.present?
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_house
      @house = House.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:house).permit(:name, :memo, room_member_ids: [])
    end

    def create_accountings
      return [] if @expenses.blank?
      members = @house.room_members
      @fee = @total.div(members.count)
      members.order(:id).map {|user|
        name = user.name
        payment = @expenses.where(room_member_id: user.id).map {|ex| ex[:payment] }.inject(:+) || 0
        amount = payment - @fee
        message = amount.negative? ? "お支払いください" : "受け取ってください"
        paid = RoomMemberHouse.where(house: @house, room_member: user).last.paid
        {
          id:          user.id,
          room_member: name,
          payment:     payment,
          amount:      amount.abs,
          message:     message,
          paid:        paid,
        }
      }
    end
end
