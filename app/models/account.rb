class Account < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :balance, presence: true
end
