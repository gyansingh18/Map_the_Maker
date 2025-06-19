class UsersController < ApplicationController
  def favorites
    @makers = current_user.favorited_by_type('Maker')
  end
end
