class ExpendituresController < ApplicationController
  before_action :set_expenditure, only: [:update, :destroy]

  def index
    records = Expenditure.search(params)

    @line_user = LineUser.find(params[:line_user_id])
    @expenditures = records.page(params[:page])
    @summary = records.summary
  end

  def create
    @expenditure = Expenditure.new(permitted_params)
    if @expenditure.save
      render json: :ok
    else
      render json: { errors: @expenditure.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @expenditure.update(permitted_params)
      render json: :ok
    else
      render json: { errors: @expenditure.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if @expenditure.destroy
      render json: :ok
    else
      render json: { errors: ["delete failed id:#{params[:id]}"] }, status: :bad_request
    end
  end

  private

    def set_expenditure
      @expenditure = Expenditure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:expenditure).permit(:line_user_id, :entry_date, :category, :payment, :memo, :margin)
    end
end
