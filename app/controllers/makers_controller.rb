class MakersController < ApplicationController
  def index
    @makers = Maker.all
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
      redirect_to maker_path(params[:id])
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def maker_params
    params.permit(:maker).require(:name, :location, :category, :description)
  end
end
