class User < ApplicationRecord
  include Clearance::User

  has_many :health_statuses

  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create

  def confirm_email
    self.email_confirmed_at = Time.current
    save
  end
end
