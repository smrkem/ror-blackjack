class Goal < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :frequency, presence: true
end
