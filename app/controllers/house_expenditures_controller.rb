class HouseExpendituresController < ApplicationController
  before_action :house_id?, only: %i[update create destroy]

  def create
    @house_expenditure = HouseExpenditure.new(permitted_params)
    if @house_expenditure.save
      render json: :ok
    else
      render json: { errors: @house_expenditure.errors.full_messages }, status: :bad_request
    end
  end

  def update
    house_expenditure = HouseExpenditure.find(params[:id])
    if house_expenditure.update(permitted_params)
      render json: :ok
    else
      render json: { errors: house_expenditure.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if Expenditure.find(params[:id]).destroy
      render json: :ok
    else
      render json: { errors: ["delete failed id:#{params[:id]}"] }, status: :bad_request
    end
  end

  private

    def house_id?
      head :bad_request if params[:house_id].blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:house_expenditure).permit(:house_id, :room_member_id, :entry_date, :category, :payment, :name)
    end
end