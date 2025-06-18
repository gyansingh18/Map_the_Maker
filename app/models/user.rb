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

  def add_karma_points(action_type)
    points = case action_type
             when :maker_added
               KarmaConfig::POINTS_FOR_ADDING_MAKER
             when :review_submitted
               KarmaConfig::POINTS_FOR_SUBMITTING_REVIEW
             when :signed_up
               KarmaConfig::POINTS_FOR_SIGNING_UP
             else
               0 # Default to 0 if the action_type is not recognized
             end
    increment!(:karma_points, points) if points > 0
  end

  after_create :set_initial_karma

  private

  def set_initial_karma
    add_karma_points(:signed_up)
  end
end
