class Exercise < ApplicationRecord
  # validations
  validates_presence_of :performed_at, :duration_minutes,:avg_heart_rate, :created_by
end
