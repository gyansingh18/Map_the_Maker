class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @maker = Maker.find(params[:maker_id])
    if @product.save
      redirect_to new_maker_review_path(@maker)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.permit(:product).require(:name, :category)
  end
end
