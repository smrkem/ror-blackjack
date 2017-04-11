class User < ApplicationRecord
  include Clearance::User

  has_many :health_statuses

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
end
