class KarmaTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true

  after_create :update_user_karma_total

  private

  def update_user_karma_total
    user.increment!(:karma_points, points_awarded)
  end
end
