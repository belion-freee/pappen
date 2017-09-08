class MaximsController < ApplicationController
  before_action :set_maxim, only: [:show, :edit, :update, :destroy]

  # GET /maxims
  # GET /maxims.json
  def index
    @maxims = Maxim.all
  end

  # GET /maxims/1
  # GET /maxims/1.json
  def show; end

  # GET /maxims/new
  def new
    @maxim = Maxim.new
    @category = Settings.maxim.category.invert
  end

  # GET /maxims/1/edit
  def edit
    @category = Settings.maxim.category.invert
  end

  # POST /maxims
  # POST /maxims.json
  def create
    @maxim = Maxim.new(maxim_params)
    @category = Settings.maxim.category.invert

    respond_to do |format|
      if @maxim.save
        format.html { redirect_to @maxim, notice: "Maxim was successfully created." }
        format.json { render :show, status: :created, location: @maxim }
      else
        format.html { render :new }
        format.json { render json: @maxim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maxims/1
  # PATCH/PUT /maxims/1.json
  def update
    respond_to do |format|
      if @maxim.update(maxim_params)
        format.html { redirect_to @maxim, notice: "Maxim was successfully updated." }
        format.json { render :show, status: :ok, location: @maxim }
      else
        format.html { render :edit }
        format.json { render json: @maxim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maxims/1
  # DELETE /maxims/1.json
  def destroy
    @maxim.destroy
    respond_to do |format|
      format.html { redirect_to maxims_url, notice: "Maxim was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_maxim
      @maxim = Maxim.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maxim_params
      params.require(:maxim).permit(:category, :remark, :author, :source, :url)
    end
end
