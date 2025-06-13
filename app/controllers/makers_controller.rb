class MakersController < ApplicationController
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

  private

  def maker_params
    params.require(:maker).permit(:name, :location, :description, categories: [], photos: [])
  end
end
