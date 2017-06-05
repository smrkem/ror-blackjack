class Goal < ApplicationRecord
  belongs_to :user
  has_many :goal_activities, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :frequency, presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

  def completions
    self.goal_activities.where("performed_at >= ?", Date.today.beginning_of_week).count
  end

  def week_completed?
    self.completions >= self.frequency
  end

end
