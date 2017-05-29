class Goal < ApplicationRecord
  belongs_to :user
  has_many :goal_activities, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :frequency, presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

  validate :deleted_at_cannot_be_future

  def deleted_at_cannot_be_future
    if deleted_at.present? && deleted_at > Time.current
      errors.add(:deleted_at, "can't be in the future")
    end
  end

  def completions
    self.goal_activities.where("performed_at >= ?", Date.today.beginning_of_week).count
  end

  def week_completed?
    self.completions >= self.frequency
  end
end
