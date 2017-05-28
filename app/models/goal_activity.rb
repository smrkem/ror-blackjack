class GoalActivity < ApplicationRecord
  belongs_to :goal

  scope :by_week, -> { order(performed_at: :desc).group_by { |ga| ga.created_at.beginning_of_week } }

  validates :performed_at, presence: true
  validate :performed_at_cannot_be_futute

  def performed_at_cannot_be_futute
    if performed_at.present? && performed_at > Time.current
      errors.add(:performed_at, "can't be in the future")
    end
  end
end
