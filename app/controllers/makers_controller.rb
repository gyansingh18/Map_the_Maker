class MakersController < ApplicationController
  before_action :set_maker, only: [:favorite, :unfavorite]
  def index
    @makers = Maker.all
    if params[:name].present?
      @makers = @makers.where("name ILIKE ?", "%#{params[:name]}%")
    end
    if params[:location].present?
      @makers = @makers.where("location ILIKE ?", "%#{params[:location]}%")
    end
    if params[:category].present?
      categories_params = params[:category].drop(1)
      categories_params.each do |category|
        @makers = @makers.select do |maker|
          maker.categories.include?(category)
        end
      end
    end

    # @markers = @makers.geocoded.map do |maker|
    #   {
    #     lat: maker.latitude,
    #     lng: maker.longitude
    #   }
    # end
  end

  def show
    @maker = Maker.find(params[:id])
    @reviews = Review.all
    @review = Review.new
    @products = Product.all
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

  def map
    @makers = Maker.all
    @markers = @makers.geocoded.map do |maker|
      {
        lat: maker.latitude,
        lng: maker.longitude
        # info_window_html: render_to_string(partial: "info_window", locals: {maker: maker })
      }
    end
  end

  def favorite
    current_user.favorite(@maker)
    redirect_to @maker, alert: "Added to favorites"
  end

  def unfavorite
    current_user.unfavorite(@maker)
    redirect_to @maker, alert: "Removed from favorites"
  end


  private

  def maker_params
    params.require(:maker).permit(:name, :location, :description, categories: [], photos: [])
  end

  def set_maker
    @maker = Maker.find(params[:id])
  end
end
