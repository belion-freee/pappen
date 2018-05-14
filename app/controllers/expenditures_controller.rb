class ExpendituresController < ApplicationController
  before_action :line_user_id?, only: [:index, :new, :edit, :destroy]

  def index
    records = Expenditure.search(params)

    @line_user = LineUser.find(params[:line_user_id])
    @expenditures = records.page(params[:page])
    @summary = records.summary
  end

  def new
    @expenditure = Expenditure.new(line_user_id: params[:line_user_id], entry_date: Time.zone.today)
  end

  def edit
    @expenditure = Expenditure.find(params[:id])
  end

  def create
    @expenditure = Expenditure.new(permitted_params)
    respond_to do |format|
      if @expenditure.save
        format.html { redirect_to expenditures_url(line_user_id: @expenditure.line_user_id) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    expenditure = Expenditure.find(params[:id])
    respond_to do |format|
      if expenditure.update(permitted_params)
        format.html { redirect_to expenditures_url(line_user_id: expenditure.line_user_id) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    Expenditure.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to expenditures_url(line_user_id: params[:line_user_id]) }
    end
  end

  private

    def line_user_id?
      head :bad_request if params[:line_user_id].blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_params
      params.require(:expenditure).permit(:line_user_id, :entry_date, :category, :payment, :memo, :margin)
    end
end
