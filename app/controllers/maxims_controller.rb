class MaximsController < ApplicationController
  before_action :set_maxim, only: %i[update destroy]

  # GET /maxims
  # GET /maxims.json
  def index
    @maxims = Maxim.page(params[:page])
    @maxim = Maxim.new
  end

  # POST /maxims
  # POST /maxims.json
  def create
    @maxim = Maxim.new(maxim_params)
    @category = Settings.maxim.category.invert

    if @maxim.save
      render json: :ok
    else
      render json: { errors: @maxim.errors.full_messages }, status: :bad_request
    end
  end

  # PATCH/PUT /maxims/1
  # PATCH/PUT /maxims/1.json
  def update
    if @maxim.update(maxim_params)
      render json: :ok
    else
      render json: { errors: @maxim.errors.full_messages }, status: :bad_request
    end
  end

  # DELETE /maxims/1
  # DELETE /maxims/1.json
  def destroy
    @maxim.destroy
    respond_to do |format|
      format.html { redirect_to maxims_url }
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
