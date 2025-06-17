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
end
