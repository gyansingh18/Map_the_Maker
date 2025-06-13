class MakersController < ApplicationController
  def index
    @makers = Maker.all
    @markers = @makers.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude
      }
    end
  end

  def show
    @maker = Maker.find(params[:id])
  end

  def new
    @maker = Maker.new
  end

  def create
    @maker = Maker.new(maker_params)
    @maker.user = current_user
    if @maker.save
      redirect_to maker_path(@maker)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def maker_params
    params.require(:maker).permit(:name, :location, :description, categories: [], photos: [])
  end
end
