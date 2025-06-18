class MakersController < ApplicationController
  before_action :set_maker, only: [:favorite, :unfavorite]
  skip_before_action :authenticate_user!, only: [:index, :show, :map]

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
    @reviews = @maker.reviews.order(created_at: :desc).limit(3)
    @review = Review.new
    @products = Product.all

    @makers = [@maker]
    @markers = @makers.map do |maker|
      {
        lat: maker.latitude,
        lng: maker.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {maker: maker}),
        marker_html: render_to_string(partial: "marker", locals: {maker: maker})
      }
    end
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
    # Start with all geocoded makers. This is crucial for map display.
    @makers = Maker.geocoded

    # Apply map-specific filters to the @makers collection
    apply_map_filters

    # Now, @makers will be the filtered and geocoded set of makers,
    # ready to be converted into markers.
    @markers = @makers.map do |maker|
      {
        lat: maker.latitude,
        lng: maker.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {maker: maker}),
        marker_html: render_to_string(partial: "marker", locals: {maker: maker})
      }
    end
  end

  def favorite
    current_user.favorite(@maker)
    redirect_to makers_path, alert: "Added to favorites"
  end

  def unfavorite
    current_user.unfavorite(@maker)
    redirect_to makers_path, alert: "Removed from favorites"
  end


  private

  def maker_params
    params.require(:maker).permit(:name, :location, :description, categories: [], photos: [])
  end

  def set_maker
    @maker = Maker.find(params[:id])
  end

   # NEW private method for map-specific filtering
  def apply_map_filters
    if params[:name].present?
      @makers = @makers.where("name ILIKE ?", "%#{params[:name]}%")
    end
    if params[:location].present?
      # Assuming you have a geocoding setup (like Geocoder gem) and makers have lat/lng
      # This will filter based on distance from the provided location
      @makers = @makers.near(params[:location], 50) # Search within 50 miles/km, adjust as needed
    end
    if params[:category].present?
      categories_to_filter = params[:category].reject(&:blank?)
      if categories_to_filter.any?
        # This uses PostgreSQL's array operator to keep it an ActiveRecord::Relation
        @makers = @makers.where("categories && ARRAY[?]::varchar[]", categories_to_filter)
      end
    end
    # Add other map-specific filters here (e.g., product, if applicable)
  end
end
