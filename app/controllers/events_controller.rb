class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update]

  def show
    @members = RoomMember.names(@event.room_members.first.gid)
    @expenses = @event.expenses.order(:id)
    @total = @expenses.map(&:payment).inject(:+) || 0
    @fee, @accountings = Expense.accounting(@expenses, @event.room_members)
  end

  def create
    permitted_params = event_params
    @event = Event.new(permitted_params)

    if @event.save
      render json: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @event.update(event_params)
      render json: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
  end

  # Deprecated
  def paid
    rme = RoomMemberEvent.where(event_id: params[:event_id], room_member_id: params[:room_member_id]).last
    rme.update(paid: params[:paid]) if rme.present?
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.includes(:room_members).includes(:expenses).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      format_params params.require(:event).permit(:name, :place, :start, :end, :memo, room_member_ids: [])
    end

    def format_params(permitted_params)
      permitted_params[:room_member_ids].delete("")
      permitted_params
    end
end
