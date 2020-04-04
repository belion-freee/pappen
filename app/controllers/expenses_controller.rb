class ExpensesController < ApplicationController
  before_action :set_expense, only: [:update, :destroy]

  def create
    @expense = Expense.new(permitted_params)
    if @expense.save
      render json: :ok
    else
      render json: { errors: @expense.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @expense.update(permitted_params)
      render json: :ok
    else
      render json: { errors: @expense.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if @expense.destroy
      render json: :ok
    else
      render json: { errors: ["delete failed id:#{params[:id]}"] }, status: :bad_request
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:expense).permit(:name, :event_id, :room_member_id, :payment, :memo, :currency, exempt_ids: [])
    end
end
