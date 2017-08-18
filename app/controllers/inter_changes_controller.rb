class InterChangesController < ApplicationController
  before_action :set_inter_change, only: [:show, :edit, :update, :destroy]

  # GET /inter_changes
  # GET /inter_changes.json
  def index
    debugger
    @inter_changes = InterChange.all
  end

  # GET /inter_changes/1
  # GET /inter_changes/1.json
  def show
  end

  # GET /inter_changes/new
  def new
    @inter_change = InterChange.new
  end

  # GET /inter_changes/1/edit
  def edit
  end

  # POST /inter_changes
  # POST /inter_changes.json
  def create
    @inter_change = InterChange.new(inter_change_params)

    respond_to do |format|
      if @inter_change.save
        format.html { redirect_to @inter_change, notice: "Inter change was successfully created." }
        format.json { render :show, status: :created, location: @inter_change }
      else
        format.html { render :new }
        format.json { render json: @inter_change.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inter_changes/1
  # PATCH/PUT /inter_changes/1.json
  def update
    respond_to do |format|
      if @inter_change.update(inter_change_params)
        format.html { redirect_to @inter_change, notice: "Inter change was successfully updated." }
        format.json { render :show, status: :ok, location: @inter_change }
      else
        format.html { render :edit }
        format.json { render json: @inter_change.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inter_changes/1
  # DELETE /inter_changes/1.json
  def destroy
    @inter_change.destroy
    respond_to do |format|
      format.html { redirect_to inter_changes_url, notice: "Inter change was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_inter_change
      @inter_change = InterChange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inter_change_params
      params.require(:inter_change).permit(:prefectures, :highway, :ic)
    end
end
