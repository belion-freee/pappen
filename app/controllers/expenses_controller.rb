class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index; end

  # GET /expenses/1
  # GET /expenses/1.json
  def show; end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @event = Event.find(params[:event_id])
  end

  # GET /expenses/1/edit
  def edit
    @event = Event.find(@expense.event_id)
  end

  # POST /expenses
  # POST /expenses.json
  def create
    permitted_params = expense_params
    @expense = Expense.new(permitted_params)
    @event = Event.find(permitted_params[:event_id])

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @event, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    @event = Event.find(@expense.event_id)
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @event, notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @event = Event.find(@expense.event_id)
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to @event, notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:name, :event_id, :room_member_id, :payment, :memo)
    end
end
