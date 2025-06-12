class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :index ]

  def home
    @popular_makers = Maker.order(Arel.sql('RANDOM()')).limit(5)

    @high_rated_reviews = Review.where("overall_rating >= ?", 4.0)
                                .order(created_at: :desc) # Or by overall_rating DESC, or randomly
                                .limit(10) # Adjust the number of reviews you want to display

    @high_rated_reviews = @high_rated_reviews.includes(:user, :maker)
  end
end
