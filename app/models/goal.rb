class Goal < ApplicationRecord
  belongs_to :user
  has_many :goal_activities, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :frequency, presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
end
