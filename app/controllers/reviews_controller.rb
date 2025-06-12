class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @maker = Maker.find(params[:maker_id])
    @products = Product.all
  end

  def create
    @review = Review.new(review_params)
    @maker = Maker.find(params[:maker_id])
    @user = current_user
    @review.user = @user
    @review.maker = @maker
    if @review.save
      @product_names = params[:review][:products]
      @product_names.each do |product|
        if product != ""
          @product = Product.find_or_create_by(name: product)
          ReviewProduct.create(product: @product, review: @review)
        end
      end
      redirect_to maker_path(@maker)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:overall_rating, :freshness_rating, :service_rating, :product_range_rating, :accuracy_rating, :comment)
  end
end
