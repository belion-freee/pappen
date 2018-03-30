class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_member, only: [:new, :create]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @expenses = Expense.where(event_id: params[:id])
    @total = @expenses.map {|ex| ex[:payment] }.inject(:+) || 0
    @accountings = create_accountings
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @members = RoomMember.where(gid: @event.room_members.first.gid)
  end

  # POST /events
  # POST /events.json
  def create
    permitted_params = event_params
    @event = Event.new(permitted_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { render :delete }
      format.json { head :no_content }
    end
  end

  # POST /paid
  def paid
    rme = RoomMemberEvent.where(event_id: params[:event_id], room_member_id: params[:room_member_id]).last
    rme.update(paid: params[:paid]) if rme.present?
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_member
      head :bad_request unless params[:rmid].present? && RoomMember.find(params[:rmid]).try(:gid).present?
      @rmid    = params[:rmid]
      @members = RoomMember.where(gid: RoomMember.find(params[:rmid]).gid)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      format_params params.require(:event).permit(:name, :place, :start, :end, :memo, room_member_ids: [])
    end

    def format_params(permitted_params)
      permitted_params[:room_member_ids].delete("")
      permitted_params
    end

    def create_accountings
      return [] if @expenses.blank?
      members = @event.room_members
      @fee = @total.div(members.count)
      members.map {|user|
        name = user.name
        payment = @expenses.where(room_member_id: user.id).map {|ex| ex[:payment] }.inject(:+) || 0
        amount = payment - @fee
        message = amount.negative? ? "お支払いください" : "受け取ってください"
        paid = RoomMemberEvent.where(event: @event, room_member: user).last.paid
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
