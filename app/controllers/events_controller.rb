class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update]

  def show
    @members = RoomMember.names(@event.room_members.first.gid)
    @expenses = @event.expenses.order(:id)
    @total = @expenses.map(&:payment).inject(:+) || 0
    @accountings = Expense.summary(@event)
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

  # TODO: Mechanizeを取り扱うModuleを作る
  def gas
    target = Mechanize.new.get(Settings.account.gogogs.uri % params[:prefectures]).search(".pref-price-panel div").find {|div|
      # 文字列だと通らないのでバイトサイズで比較
      div.at("label")&.inner_text&.bytesize == 15
    }
    raise "target is null. May be gogo.gs site DOM had been changed!" if target.blank?
    cost = target.at(".price")&.inner_text.to_f * (params[:km].to_i.div(params[:gm].to_f))
    render json: { cost: cost.round }, status: :ok
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
