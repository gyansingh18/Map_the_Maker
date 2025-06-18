class User < ApplicationRecord
  acts_as_favoritor
  has_many :makers, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :questions, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # This is a workaround for there being no RegistrationsController for Devise
  def after_database_authentication
    add_karma_points(:signed_up) unless KarmaTransaction.exists?(user: self, source_type: nil, action_type: :signed_up)
  end

  def add_karma_points(action_type, source: nil)
    points_to_award = case action_type
                      when :maker_added
                        KarmaConfig::POINTS_FOR_ADDING_MAKER
                      when :review_submitted
                        KarmaConfig::POINTS_FOR_SUBMITTING_REVIEW
                      when :signed_up
                        KarmaConfig::POINTS_FOR_SIGNING_UP
                      else
                        0
                      end

    if points_to_award > 0
      KarmaTransaction.create!(
        user: self,
        points_awarded: points_to_award,
        source: source
      )
    end
  end
end
