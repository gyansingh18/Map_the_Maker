class MakersController < ApplicationController
  def index
    @makers = Maker.all
    filter_makers
    # redirect_to map_makers_path(request.query_parameters)

    if params[:map_search].present? && params[:map_search] == 'true'
      redirect_to map_makers_path(request.query_parameters)
    else
      # No explicit render needed, Rails will render index.html.erb by default
    end

  end

  def show
    @maker = Maker.find(params[:id])
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
    filter_makers
    @markers = @makers.geocoded.map do |maker|
      {
        lat: maker.latitude,
        lng: maker.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {maker: maker}),
        marker_html: render_to_string(partial: "marker", locals: {maker: maker})
      }
    end
    # redirect_to map_makers_path
  end

  private

  def maker_params
    params.require(:maker).permit(:name, :location, :description, categories: [], photos: [])
  end

  def filter_makers
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
end
