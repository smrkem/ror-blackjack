class User < ApplicationRecord
  include Clearance::User

  has_many :health_statuses
  has_many :goals

  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create

  def confirm_email
    self.email_confirmed_at = Time.current
    save
  end

  def active_goals
    self.goals.where(deleted_at: nil)
  end

  def inactive_goals
    self.goals.where.not(deleted_at: nil)
  end
end
