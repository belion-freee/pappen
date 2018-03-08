class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where(gid: params[:gid])
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
    @room_members = RoomMember.where(gid: params[:gid])
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events
  # POST /events.json
  def create
    permitted_params = event_params
    @event = Event.new(permitted_params.except(:uids))

    respond_to do |format|
      if @event.save && @event.update(uids: permitted_params[:uids])
        format.html { redirect_to @event, notice: "Event was successfully created." }
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
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      format_params params.require(:event).permit(:name, :place, :start, :end, :memo, uids: [])
    end

    def format_params(permitted_params)
      permitted_params[:uids].delete("")
      raise "member should be exist at least 1" if permitted_params[:uids].blank?
      permitted_params
    end

    def create_accountings
      return [] if @expenses.blank?
      members = @event.users
      fee = @total.div(members.count)
      members.map {|user|
        name = user.name
        payment = @expenses.where(uids: user.id).map {|ex| ex[:payment] }.inject(:+) || 0
        amount = payment - fee
        message = amount.negative? ? "お支払いください" : "受け取ってください"
        {
          user:    name,
          payment: payment,
          fee:     fee,
          amount:  amount.abs,
          message: message,
        }
      }
    end
end
