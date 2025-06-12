class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @popular_makers = Maker.order(Arel.sql('RANDOM()')).limit(5)
  end
end
