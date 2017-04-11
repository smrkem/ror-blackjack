class HealthStatus < ApplicationRecord
  belongs_to :user

  scope :for_range, ->(start_date) { order(:created_at).where(created_at: start_date..Time.now) }
  scope :by_month, -> { order(created_at: :desc).group_by { |h| h.created_at.beginning_of_month } }

  validates :mindfulness, presence: true
  validates :physically_active, presence: true
  validates :happiness, presence: true
  validates :diet, presence: true
  validates :mentally_active, presence: true
  validates :socially_active, presence: true

  def as_json(options={})
    {
      mindfulness: self.mindfulness,
      physically_active: self.physically_active,
      happiness: self.happiness,
      diet: self.diet,
      mentally_active: self.mentally_active,
      socially_active: self.socially_active,
      created_at: self.created_at.strftime("%s")
    }
  end
end
