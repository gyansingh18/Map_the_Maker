class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @maker = Maker.find(params[:maker_id])
  end

  def create
    @review = Review.new
    @maker = Maker.find(params[:maker_id])
    @user = current_user
    @review.user = @user
    @review.maker = @maker
    if @review.save
      redirect_to maker_path(@maker)
    else
      render :new, status: :unprocessable_entity
    end
  end
end
