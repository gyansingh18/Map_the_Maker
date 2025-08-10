class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @popular_makers = Maker.order(Arel.sql('RANDOM()')).limit(5)

    @high_rated_reviews = Review.where("overall_rating >= ?", 4.0)
                                .order(created_at: :desc)
                                .limit(10)

    @high_rated_reviews = @high_rated_reviews.includes(:user, :maker)
  end

  def karma
  end

end
